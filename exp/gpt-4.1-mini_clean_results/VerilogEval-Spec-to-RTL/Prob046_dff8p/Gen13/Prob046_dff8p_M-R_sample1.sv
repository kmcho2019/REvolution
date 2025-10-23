module DFF_sync_reset_negclk_1bit (
    input       clk,
    input       reset,
    input       d,
    input       reset_val,
    output reg  q
);
    // Negative edge triggered DFF with synchronous active-high reset to reset_val
    always @(negedge clk) begin
        if (reset)
            q <= reset_val;
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
    // Parameterized reset vector 0x34 to provide per-bit reset values
    localparam [7:0] RESET_VEC = 8'h34;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_bits
            DFF_sync_reset_negclk_1bit dff_inst (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .reset_val(RESET_VEC[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule