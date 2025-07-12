module SyncResetNegEdgeReg8 #(
    parameter RESET_VAL = 8'h34
) (
    input           clk,
    input           reset,
    input   [7:0]   d,
    output reg [7:0] q
);

    always @(negedge clk) begin
        q <= reset ? RESET_VAL : d;
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