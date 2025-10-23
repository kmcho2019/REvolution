module DFF8_negclk_sync_reset_ce (
    input          clk,
    input          reset,
    input  [7:0]   d,
    output reg [7:0] q
);
    localparam [7:0] RESET_VAL = 8'h34;

    // Clock enable: update only when input differs from current q (reset handled separately)
    wire clk_en = (d != q);

    always @(negedge clk) begin
        if (reset) begin
            q <= RESET_VAL;
        end else if (clk_en) begin
            q <= d;
        end
    end

endmodule

module TopModule (
    input          clk,
    input          reset,
    input  [7:0]   d,
    output [7:0]   q
);

    DFF8_negclk_sync_reset_ce reg8_inst (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );

endmodule