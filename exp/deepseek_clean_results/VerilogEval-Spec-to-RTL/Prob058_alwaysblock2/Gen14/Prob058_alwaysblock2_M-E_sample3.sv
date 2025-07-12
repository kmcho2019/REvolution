module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output wire out_always_comb,
    output reg  out_always_ff
);

    // LUT-based continuous assignment
    wire [3:0] lut = {1'b0, 1'b1, 1'b1, 1'b0};
    assign out_assign = lut[{a,b}];

    // Time-multiplexed combinational logic
    reg sel;
    wire a_val = sel ? a : 1'b0;
    wire b_val = sel ? 1'b0 : b;
    assign out_always_comb = a_val | b_val;

    always @(posedge clk) begin
        sel <= ~sel;
    end

    // Two-stage pipelined sequential XOR
    reg stage1;
    always @(posedge clk) begin
        stage1 <= a ^ b;       // First pipeline stage
        out_always_ff <= stage1; // Second pipeline stage
    end

endmodule