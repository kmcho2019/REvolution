module NegEdgeDFF (
    input clk,
    input d,
    output reg q
);
    always @(negedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input clk,
    input a,
    output q
);
    // Store 'a' on negative edge, output as q
    NegEdgeDFF neg_dff_inst (
        .clk(clk),
        .d(a),
        .q(q)
    );
endmodule