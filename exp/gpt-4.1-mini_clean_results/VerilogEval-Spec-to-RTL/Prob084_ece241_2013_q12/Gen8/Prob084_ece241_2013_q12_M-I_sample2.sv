module TopModule (
    input  clk,
    input  enable,
    input  S,
    input  A,
    input  B,
    input  C,
    output Z
);

    reg [7:0] Q;
    wire gated_clk;

    // Simple clock gating: gated clock active only when enable is high
    assign gated_clk = clk & enable;

    // Shift register using gated clock to reduce power consumption when enable=0
    always @(posedge gated_clk) begin
        Q <= {Q[6:0], S};
    end

    // Output Z selected by ABC as index into Q
    assign Z = Q[{A,B,C}];

endmodule