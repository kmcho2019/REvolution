module SyncResetPosEdgeReg8_ClkGated #(
    parameter RESET_VAL = 8'h34
) (
    input           clk,
    input           reset,
    input   [7:0]   d,
    output reg [7:0] q
);
    // Internal inverted clock for triggering on negative edge of original clk
    wire inv_clk = ~clk;

    // Clock enable signal: enable only when reset active or input differs from output
    wire clk_en = reset | (d != q);

    // Clock gating (simple AND gate)
    wire gated_clk = inv_clk & clk_en;

    always @(posedge gated_clk) begin
        if (reset)
            q <= RESET_VAL;
        else
            q <= d;
    end
endmodule

module TopModule (
    input          clk,
    input          reset,
    input  [7:0]   d,
    output [7:0]   q
);

    SyncResetPosEdgeReg8_ClkGated #(.RESET_VAL(8'h34)) reg8 (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );

endmodule