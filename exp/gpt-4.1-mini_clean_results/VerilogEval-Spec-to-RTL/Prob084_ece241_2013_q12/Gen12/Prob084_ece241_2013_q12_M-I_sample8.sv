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

    // Clock gating: gated_clk only toggles when enable is high to reduce power
    assign gated_clk = clk & enable;

    // Shift register clocked by gated_clk, shifts in S at Q[0] when enable is high
    // When enable=0, gated_clk doesn't toggle, so Q holds its state.
    always @(posedge gated_clk) begin
        Q <= {Q[6:0], S};
    end

    // Output Z is selected from Q based on 3-bit address {A,B,C}
    assign Z = Q[{A,B,C}];

endmodule