module LFSR #(
    parameter WIDTH = 4, // Parameter for the width of the LFSR
    parameter POLY_MSB = 3, // Polynomial for MSB calculation
    parameter POLY_2ND_MSB = 2 // Polynomial for 2nd MSB calculation
)(
    input  logic clk, // Input clock signal
    input  logic rst, // Active high reset signal
    output logic [WIDTH-1:0] out // 4-bit output representing the current state of the LFSR
);

reg [WIDTH-1:0] state; // Internal register to hold the current state
logic feedback; // Feedback signal calculated from the state

// Calculate feedback based on the XOR of specific bits in the register
assign feedback = ~(state[POLY_MSB] ^ state[POLY_2ND_MSB]);

// Sequential logic for shifting and initialization
always_ff @ (posedge clk) begin
    if (rst) begin
        state <= {WIDTH{1'b0}}; // Initialize register to zero on reset
    end else begin
        // Shift left and insert feedback at the LSB
        state <= {state[WIDTH-2:0], feedback};
    end
end

// Continuous assignment for output
assign out = state;

endmodule

// Example testbench for the LFSR module
module tb_LFSR;
logic clk, rst;
logic [3:0] out;

LFSR #(.WIDTH(4), .POLY_MSB(3), .POLY_2ND_MSB(2)) uut (
    .clk(clk),
    .rst(rst),
    .out(out)
);

// Clock generation
always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    #10 rst = 0;
    #100 $finish;
end

endmodule