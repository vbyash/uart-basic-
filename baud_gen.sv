module baud_gen #(
	parameter BAUD_RATE = 9600,
	parameter SYS_FREQUENCY = 1000000
)(
	input sys_clk, reset,
	output reg uart_clk
);

localparam clk_count = SYS_FREQUENCY/BAUD_RATE;
integer counter;
always @(posedge sys_clk) begin
	if(reset) begin 
		counter <= 0;
		uart_clk <= 0;
	end
	else begin
		if(counter < clk_count/2) begin
			counter <= counter + 1;
		end
		else begin
			counter <= 0;
			uart_clk <= ~uart_clk;
		end
	end
end

endmodule