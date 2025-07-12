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
    output reg q
);
    wire negdff_q;

    // Instantiate a negative edge triggered flip-flop to capture 'a'
    NegEdgeDFF neg_dff_inst (
        .clk(clk),
        .d(a),
        .q(negdff_q)
    );

    // On positive clock edge, output q is inversion of stored negedge DFF output
    always @(posedge clk) begin
        q <= ~negdff_q;
    end
endmodule