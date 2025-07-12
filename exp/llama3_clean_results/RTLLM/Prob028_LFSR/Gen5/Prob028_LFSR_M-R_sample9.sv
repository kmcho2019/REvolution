module LFSR #(
    parameter WIDTH = 4 // Parameter for the width of the LFSR
)(
    input  logic clk, // Input clock signal
    input  logic rst, // Active high reset signal
    output logic [WIDTH-1:0] out // 4-bit output representing the current state of the LFSR
);

reg [WIDTH-1:0] state; // Internal register to hold the current state

// Sequential logic for shifting and initialization
always_ff @ (posedge clk) begin
    if (rst) begin
        state <= '0; // Initialize register to zero on reset
    end else begin
        // Calculate feedback based on the XOR of specific bits in the register
        // and shift left, inserting feedback at the LSB
        state <= {state[WIDTH-2:0], ~(state[WIDTH-1] ^ state[WIDTH-2])};
    end
end

// Continuous assignment for output
assign out = state;

endmodule

// Example testbench for the LFSR module
module tb_LFSR;
logic clk; // Clock signal
logic rst; // Reset signal
logic [3:0] out; // Output of the LFSR

// Instantiate the LFSR module
LFSR #(.WIDTH(4)) uut (
    .clk(clk),
    .rst(rst),
    .out(out)
);

// Initial block to initialize the clock and reset signals
initial begin
    clk = 0;
    rst = 1;
    #5 rst = 0; // Deassert reset after 5 time units
end

// Always block to generate the clock signal
always #5 clk = ~clk; // Toggle the clock every 5 time units

// Finish the simulation after 100 time units
initial #100 $finish;

// Monitor output
initial begin
    $monitor("out = %b", out);
end

endmodule