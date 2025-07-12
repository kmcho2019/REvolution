module DFF_sync_reset_negclk_vector_ce #(
    parameter WIDTH = 8,
    parameter [WIDTH-1:0] RESET_VAL = 8'h34
) (
    input                  clk,
    input                  reset,
    input  [WIDTH-1:0]     d,
    output reg [WIDTH-1:0] q
);
    // Internal clock enable: only update q when d != q or reset active
    wire ce = (d != q);

    always @(negedge clk) begin
        if (reset)
            q <= RESET_VAL;
        else if (ce)
            q <= d;
        else
            q <= q; // hold current state explicitly
    end
endmodule

module TopModule (
    input          clk,
    input          reset,
    input  [7:0]   d,
    output [7:0]   q
);
    DFF_sync_reset_negclk_vector_ce #(
        .WIDTH(8),
        .RESET_VAL(8'h34)
    ) reg8 (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );
endmodule