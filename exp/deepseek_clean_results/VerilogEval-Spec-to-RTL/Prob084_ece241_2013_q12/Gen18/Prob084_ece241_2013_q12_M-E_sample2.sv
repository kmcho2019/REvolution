module HybridRegister (
    input clk,
    input enable,
    input S,
    output reg [7:0] Q
);
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};  // Shift operation
        end
    end
endmodule

module Decoder3to8 (
    input [2:0] in,
    output reg [7:0] out
);
    always @(*) begin
        out = 8'b0;
        out[in] = 1'b1;
    end
endmodule

module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    wire [7:0] Q;
    wire [2:0] sel = {A, B, C};
    wire [7:0] decoded;
    wire [7:0] and_out;
    
    HybridRegister reg_inst (
        .clk(clk),
        .enable(enable),
        .S(S),
        .Q(Q)
    );

    Decoder3to8 decoder (
        .in(sel),
        .out(decoded)
    );

    // AND array
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : and_array
            assign and_out[i] = Q[i] & decoded[i];
        end
    endgenerate

    // OR reduction
    assign Z = |and_out;
endmodule