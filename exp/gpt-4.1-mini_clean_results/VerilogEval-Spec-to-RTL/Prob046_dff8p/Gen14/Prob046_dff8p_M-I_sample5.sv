module SyncResetNegEdgeReg8 #(
    parameter RESET_VAL = 8'h34
) (
    input           clk,
    input           reset,
    input   [7:0]   d,
    output reg [7:0] q
);

    // Internal inverted clock for positive edge triggering
    wire clk_inv = ~clk;

    // Clock enable for power saving: only update when d changes or reset is asserted
    reg [7:0] d_reg;
    wire clk_en = reset | (d != d_reg);

    always @(posedge clk_inv) begin
        if (reset) begin
            q <= RESET_VAL;
            d_reg <= RESET_VAL;
        end else if (clk_en) begin
            q <= d;
            d_reg <= d;
        end
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