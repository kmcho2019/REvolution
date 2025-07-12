module DFF_SyncResetNegEdge #(
    parameter RESET_VAL_BIT = 1'b0
) (
    input clk,
    input reset,
    input d,
    output reg q
);
    // Negative edge triggered DFF with synchronous active-high reset.
    // On reset, q loads RESET_VAL_BIT instead of zero.
    always @(negedge clk) begin
        if (reset)
            q <= RESET_VAL_BIT;
        else
            q <= d;
    end
endmodule

module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output [7:0] q
);
    // Parameter for reset value 0x34
    localparam [7:0] RESET_VAL = 8'h34;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dffs
            DFF_SyncResetNegEdge #(
                .RESET_VAL_BIT(RESET_VAL[i])
            ) dff_i (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate

endmodule