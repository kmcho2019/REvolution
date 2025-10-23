module SyncResetNegEdgeReg8_ClockEnable #(
    parameter RESET_VAL = 8'h34
) (
    input           clk,
    input           reset,
    input   [7:0]   d,
    output reg [7:0] q
);

    wire ce = reset | (d != q); // clock enable: active if reset or input data changed

    always @(negedge clk) begin
        if (reset)
            q <= RESET_VAL;
        else if (ce)
            q <= d;
        // else retain q, no toggle
    end
endmodule

module TopModule (
    input          clk,
    input          reset,
    input  [7:0]   d,
    output [7:0]   q
);

    SyncResetNegEdgeReg8_ClockEnable #(.RESET_VAL(8'h34)) reg8 (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );

endmodule