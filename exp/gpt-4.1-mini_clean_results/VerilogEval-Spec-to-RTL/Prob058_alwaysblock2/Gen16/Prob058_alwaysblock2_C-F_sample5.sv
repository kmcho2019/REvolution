module XorGate (
    input wire x,
    input wire y,
    output wire z
);
    // Structural gate-level XOR primitive
    xor (z, x, y);
endmodule

module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

wire xor_structural;

// Instantiate structural XOR gate for out_assign
XorGate xor_instance (
    .x(a),
    .y(b),
    .z(xor_structural)
);

assign out_assign = xor_structural;

// Combinational always block with direct XOR operator
always @(*) begin
    out_always_comb = a ^ b;
end

// Sequential always block registering XOR result on posedge clk
always @(posedge clk) begin
    out_always_ff <= a ^ b;
end

endmodule