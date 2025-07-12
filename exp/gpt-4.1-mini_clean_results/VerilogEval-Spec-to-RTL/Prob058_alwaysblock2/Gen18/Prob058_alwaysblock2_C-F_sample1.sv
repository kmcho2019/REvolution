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

// Instantiate structural XOR gate for shared XOR result
XorGate xor_instance (
    .x(a),
    .y(b),
    .z(xor_structural)
);

// Assign structural XOR output directly to out_assign
assign out_assign = xor_structural;

// Combinational always block using structural XOR signal
always @(*) begin
    out_always_comb = xor_structural;
end

// Sequential always block registering structural XOR output on posedge clk
always @(posedge clk) begin
    out_always_ff <= xor_structural;
end

endmodule