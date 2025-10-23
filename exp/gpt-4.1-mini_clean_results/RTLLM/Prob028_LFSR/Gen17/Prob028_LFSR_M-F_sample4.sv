// LFSR module as originally specified, with added comments
module LFSR (
    input  wire       clk,   // Clock signal
    input  wire       rst,   // Active-high synchronous reset
    output reg  [3:0] out    // Current state of the LFSR
);

// Combinational feedback calculation: inverted XOR of MSB and second MSB
wire feedback;
assign feedback = ~(out[3] ^ out[2]);

always @(posedge clk) begin
    if (rst)
        out <= 4'b0001;  // Non-zero seed to avoid lock-up at zero
    else
        out <= {out[2:0], feedback}; // Shift left and insert feedback at LSB
end

endmodule


// Minimal testbench for LFSR to demonstrate correct connectivity and simulation
module tb_LFSR();

reg clk_tb;
reg rst_tb;
wire [3:0] out_tb;

// Instantiate the LFSR module
LFSR uut (
    .clk(clk_tb),
    .rst(rst_tb),
    .out(out_tb)
);

initial begin
    // Initialize signals
    clk_tb = 0;
    rst_tb = 1;  // Apply reset initially
    #10;
    rst_tb = 0;  // Release reset

    // Run for some clock cycles to observe LFSR output
    #100;

    $finish;  // End simulation
end

// Clock generation: 10 time units period
always #5 clk_tb = ~clk_tb;

endmodule