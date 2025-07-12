module TopModule (
    input        clk,
    input        enable,
    input        S,
    input        A,
    input        B,
    input        C,
    output       Z
);

    reg [7:0] Q;
    wire gated_clk;

    // Simple clock gating: gated clock active only when enable is high
    assign gated_clk = clk & enable;

    // 8-bit shift register with clock gating to reduce toggling
    always @(posedge gated_clk) begin
        Q[0] <= S;
        Q[1] <= Q[0];
        Q[2] <= Q[1];
        Q[3] <= Q[2];
        Q[4] <= Q[3];
        Q[5] <= Q[4];
        Q[6] <= Q[5];
        Q[7] <= Q[6];
    end

    // 8-to-1 multiplexer output using direct indexed read from Q
    assign Z = Q[{A, B, C}];

endmodule