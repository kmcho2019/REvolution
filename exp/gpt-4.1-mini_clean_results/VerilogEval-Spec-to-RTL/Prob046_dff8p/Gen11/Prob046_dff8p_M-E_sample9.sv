module DFF_negclk_sync_reset (
    input clk,
    input reset,
    input d,
    output reg q,
    input reset_val
);
    always @(negedge clk) begin
        if (reset)
            q <= reset_val;
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
    // Constant reset vector 0x34 (binary 0011_0100)
    localparam [7:0] RESET_VECTOR = 8'h34;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dffs
            DFF_negclk_sync_reset ff_inst (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .q(q[i]),
                .reset_val(RESET_VECTOR[i])
            );
        end
    endgenerate
endmodule