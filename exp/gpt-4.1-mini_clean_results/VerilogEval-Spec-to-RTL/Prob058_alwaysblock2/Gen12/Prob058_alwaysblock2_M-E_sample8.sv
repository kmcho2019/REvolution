module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    wire xor_wire;

    // Intermediate XOR wire
    assign xor_wire = a ^ b;

    // Assign output directly from the XOR wire
    assign out_assign = xor_wire;

    // Combinational always block driving out_always_comb from xor_wire
    always @(*) begin
        out_always_comb = xor_wire;
    end

    // Two-stage pipeline for sequential output
    reg stage1;

    always @(posedge clk) begin
        stage1 <= xor_wire;
        out_always_ff <= stage1;
    end

endmodule