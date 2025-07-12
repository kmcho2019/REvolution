module DFF_sync_reset_negclk (
    input  clk,
    input  reset,
    input  d,
    output reg q,
    input  preset_val
);
    // Single-bit negative edge triggered DFF with synchronous active-high reset to preset_val
    always @(negedge clk) begin
        if (reset)
            q <= preset_val;
        else
            q <= d;
    end
endmodule

module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  d,
    output [7:0]  q
);
    // Reset vector constant
    localparam [7:0] RESET_VAL = 8'h34;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_array
            DFF_sync_reset_negclk dff_inst (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .q(q[i]),
                .preset_val(RESET_VAL[i])
            );
        end
    endgenerate
endmodule