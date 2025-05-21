module uart_rx (
	input rxd_i,
	input reset, uart_clk,
	output reg [7:0] rx_data_o,
	output reg rx_done	
);

enum bit[1:0] {idle = 2'b00, collect = 2'b01, done = 2'b10} state;
reg [3:0] counter;
reg [7:0] data_o;

always @(posedge uart_clk, posedge reset) begin
	if(reset) begin
		state <= idle;
		counter <= 0;
		rx_done <= 0;
		rx_data_o <= 0;
		data_o <= 0;
	end
	
	else begin
		case(state)
			idle: begin
				counter <= 0;
				rx_done <= 1'b0;
				if(~rxd_i) begin
					state <= collect;
					counter <= 0;
				end
				else begin
					state <= idle;
				end
			end
			
			collect: begin
				if(counter < 8) begin
					data_o <= {rxd_i, data_o[7:1]};
					counter <= counter + 1;
				end 
				
				else begin
					rx_data_o <= data_o;
					state <= done;
				end
			end
			
			done: begin
				state <= idle;
				rx_done	<= 1'b1;	
			end		
		endcase
	end
end

endmodule
