module DFF_negclk_sync_reset #(
    parameter RESET_VAL = 1'b0
) (
    input       clk,
    input       reset,
    input       d,
    output reg  q
);
    // Single-bit negative edge triggered D flip-flop with synchronous active-high reset
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
    // Parameter for reset value per bit
    localparam [7:0] RESET_VAL = 8'h34;

    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : gen_dffs
            DFF_negclk_sync_reset #(
                .RESET_VAL(RESET_VAL[i])
            ) dff_inst (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule