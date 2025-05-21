module uart_top #( 
	parameter BAUD_RATE = 9600,
	parameter SYS_FREQUENCY = 1000000
)(
	input sys_clk, reset,
	input [7:0] tx_data_i,
	input new_data,
	output txd_o, tx_done,
	input rxd_i,
	output rx_done,
	output [7:0] rx_data_o	
);

wire u_clk;


baud_gen #(
	.BAUD_RATE(BAUD_RATE),
	.SYS_FREQUENCY(SYS_FREQUENCY)
) baud_inst (
	.sys_clk(sys_clk),
	.reset(reset),
	.uart_clk(u_clk)
);

uart_tx uart_tx_inst (
	.new_data(new_data),
	.tx_data_i(tx_data_i), 
	.uart_clk(u_clk), 
	.reset(reset),
	.tx_done(tx_done), 
	.txd_o(txd_o)
);

uart_rx uart_rx_inst(
	.rxd_i(rxd_i),
	.reset(reset), 
	.uart_clk(u_clk),
	.rx_data_o(rx_data_o),
	.rx_done(rx_done)	
);


endmodule