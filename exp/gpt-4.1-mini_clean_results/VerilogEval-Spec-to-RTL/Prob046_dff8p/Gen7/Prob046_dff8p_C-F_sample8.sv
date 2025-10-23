module SyncResetNegEdgeReg8 #(
    parameter RESET_VAL = 8'h34
) (
    input           clk,
    input           reset,
    input   [7:0]   d,
    output reg [7:0] q
);
    // Negative edge triggered 8-bit register with synchronous active-high reset
    always @(negedge clk) begin
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

    SyncResetNegEdgeReg8 #(.RESET_VAL(8'h34)) reg8 (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );

endmodule