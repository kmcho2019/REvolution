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
reg xor_comb;
reg xor_pipeline_stage;

XorGate xor_instance (
    .x(a),
    .y(b),
    .z(xor_structural)
);

assign out_assign = xor_structural;

always @(*) begin
    case ({a, b})
        2'b00: xor_comb = 1'b0;
        2'b01: xor_comb = 1'b1;
        2'b10: xor_comb = 1'b1;
        2'b11: xor_comb = 1'b0;
        default: xor_comb = 1'b0;
    endcase
    out_always_comb = xor_comb;
end

always @(posedge clk) begin
    // Two-stage pipeline: stage 1 (combinational logic inside always block, blocking assignment)
    xor_pipeline_stage = a ^ b;
    // stage 2 (registered output)
    out_always_ff <= xor_pipeline_stage;
end

endmodule