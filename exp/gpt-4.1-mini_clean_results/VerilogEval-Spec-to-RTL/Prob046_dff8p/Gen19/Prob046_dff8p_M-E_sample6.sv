module DFF_negclk_sync_reset #(
    parameter RESET_VAL = 1'b0
) (
    input clk,
    input reset,
    input d,
    output reg q
);
    always @(negedge clk) begin
        if (reset)
            q <= RESET_VAL;
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
    // Reset pattern 0x34 = 8'b00110100
    localparam [7:0] RESET_PATTERN = 8'h34;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_array
            DFF_negclk_sync_reset #(
                .RESET_VAL(RESET_PATTERN[i])
            ) dff_inst (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule