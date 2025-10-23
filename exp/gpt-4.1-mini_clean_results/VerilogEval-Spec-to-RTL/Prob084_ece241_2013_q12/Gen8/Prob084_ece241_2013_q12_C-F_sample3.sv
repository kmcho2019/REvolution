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
    wire [2:0] sel = {A, B, C};

    // Clock gating to reduce dynamic power when enable is low
    wire gated_clk = clk & enable;

    always @(posedge gated_clk) begin
        // Shift register shifting left, new MSB bit S into Q[0]
        Q <= {Q[6:0], S};
    end

    assign Z = Q[sel];

endmodule