module DFF8_negclk_sync_reset_ce (
    input          clk,
    input          reset,
    input  [7:0]   d,
    output reg [7:0] q
);
    localparam [7:0] RESET_VAL = 8'h34;

    // Clock enable: update only when reset or input differs from current q
    wire clk_en = reset | (d ^ q) != 8'b0;

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