`timescale 1ns/1ps

module uart_tb;

	// Parameters
	localparam BAUD_RATE = 9600;
	localparam SYS_FREQUENCY = 1000000;
	localparam CLK_PERIOD = 1_000_000_000 / SYS_FREQUENCY; // ns

	// DUT Inputs
	reg sys_clk = 0;
	reg reset = 1;
	reg [7:0] tx_data_i = 8'd0;
	reg new_data = 0;
	wire txd_o;

	// DUT Outputs
	wire tx_done;
	wire rx_done;
	wire [7:0] rx_data_o;

	// Wire TX to RX
	wire rxd_i = txd_o;

	// Instantiate DUT
	uart_top #(
		.BAUD_RATE(BAUD_RATE),
		.SYS_FREQUENCY(SYS_FREQUENCY)
	) dut (
		.sys_clk(sys_clk),
		.reset(reset),
		.tx_data_i(tx_data_i),
		.new_data(new_data),
		.txd_o(txd_o),
		.tx_done(tx_done),
		.rxd_i(rxd_i),
		.rx_done(rx_done),
		.rx_data_o(rx_data_o)
	);

	// Clock generation
	always #(CLK_PERIOD/2) sys_clk = ~sys_clk;

	// Initial block
	initial begin
		$dumpfile("uart.vcd");
		$dumpvars(0, uart_tb);

		// Reset
		#(20 * CLK_PERIOD);
		reset = 0;
		#(10 * CLK_PERIOD); // settle

		// Send 1st byte
		tx_data_i = 8'hA5;
		new_data  = 1;
		$display("[%0t] Sending: %h", $time, 8'hA5);
		#(110 * CLK_PERIOD);
		new_data = 0;
		wait(tx_done == 1);
		wait(rx_done == 1);
		#(2 * CLK_PERIOD);
		if (rx_data_o == 8'hA5) $display("? PASS: Received = %h", rx_data_o);
		else $display("? FAIL: Expected = A5, Got = %h", rx_data_o);

		// Send 2nd byte
		tx_data_i = 8'h5A;
		new_data  = 1;
		$display("[%0t] Sending: %h", $time, 8'h5A);
		#(110 * CLK_PERIOD);
		new_data = 0;
		wait(tx_done == 1);
		wait(rx_done == 1);
		#(2 * CLK_PERIOD);
		if (rx_data_o == 8'h5A) $display("? PASS: Received = %h", rx_data_o);
		else $display("? FAIL: Expected = 5A, Got = %h", rx_data_o);

		// Send 3rd byte
		tx_data_i = 8'hFF;
		new_data  = 1;
		$display("[%0t] Sending: %h", $time, 8'hFF);
		#(110 * CLK_PERIOD);
		new_data = 0;
		wait(tx_done == 1);
		wait(rx_done == 1);
		#(2 * CLK_PERIOD);
		if (rx_data_o == 8'hFF) $display("? PASS: Received = %h", rx_data_o);
		else $display("? FAIL: Expected = FF, Got = %h", rx_data_o);

		// Send 4th byte
		tx_data_i = 8'h00;
		new_data  = 1;
		$display("[%0t] Sending: %h", $time, 8'h00);
		#(110 * CLK_PERIOD);
		new_data = 0;
		wait(tx_done == 1);
		wait(rx_done == 1);
		#(2 * CLK_PERIOD);
		if (rx_data_o == 8'h00) $display("? PASS: Received = %h", rx_data_o);
		else $display("? FAIL: Expected = 00, Got = %h", rx_data_o);

		// Send 5th byte
		tx_data_i = 8'hC3;
		new_data  = 1;
		$display("[%0t] Sending: %h", $time, 8'hC3);
		#(110 * CLK_PERIOD);
		new_data = 0;
		wait(tx_done == 1);
		wait(rx_done == 1);
		#(2 * CLK_PERIOD);
		if (rx_data_o == 8'hC3) $display("? PASS: Received = %h", rx_data_o);
		else $display("? FAIL: Expected = C3, Got = %h", rx_data_o);

		$display("? All tests complete.");
		$finish;
	end

endmodule
