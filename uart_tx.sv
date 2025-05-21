module uart_tx (
	input new_data,
	input [7:0] tx_data_i, 
	input uart_clk, reset,
	output reg tx_done, 
	output reg txd_o
);

reg [7:0] data_in;
enum bit[1:0]{idle = 2'b00, start = 2'b01, send = 2'b10, done = 2'b11} state;
reg [3:0]counter;

always @(posedge uart_clk, posedge reset) begin
	if(reset) begin
		state <= idle;
		data_in <= 0;
		counter <= 0;
		txd_o <= 1'b1;
		tx_done <= 1'b0;
	end
	
	else begin
		case(state)
		
			idle: begin
				txd_o <= 1'b1;
				tx_done <= 1'b0;
				
				if(new_data) begin
					data_in <= tx_data_i;
					state <= start;				
				end
				
				else begin
					state <= idle;
				end
			end
			
			start: begin
				txd_o <= 1'b0;
				state <= send;
			end 
			
			send: begin
				if(counter < 8) begin
					txd_o <= data_in[0];
					data_in <= data_in >> 1;
					counter <= counter + 1;
					state <= send;
				end
				
				else begin
					state <= done;
					counter <= 0;
				end
			end
				
			done: begin
				txd_o <= 1'b1;
				tx_done <= 1'b1;
				state <= idle;
			end
			
			default: state <= idle;	
			
		endcase
	end
end

endmodule
