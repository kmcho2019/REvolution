module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output wire out_always_comb,
    output reg  out_always_ff
);

    // XOR submodule for reusable logic
    wire xor_result;
    XOR_GATE xor_inst (
        .a(a),
        .b(b),
        .out(xor_result)
    );

    // Buffered continuous assignment
    reg out_assign_buf;
    assign out_assign = out_assign_buf;
    always @(*) out_assign_buf = xor_result;

    // Buffered combinational always output
    reg out_comb_buf;
    assign out_always_comb = out_comb_buf;
    always @(*) out_comb_buf = xor_result;

    // Clock-gated sequential output
    wire clk_enable = (a != $past(a)) || (b != $past(b));
    always @(posedge clk) begin
        if (clk_enable) begin
            out_always_ff <= xor_result;
        end
    end

endmodule

// Reusable XOR module
module XOR_GATE (
    input a,
    input b,
    output out
);
    assign out = a ^ b;
endmodule