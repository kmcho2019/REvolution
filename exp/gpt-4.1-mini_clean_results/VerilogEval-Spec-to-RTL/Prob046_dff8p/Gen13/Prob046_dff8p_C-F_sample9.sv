module DFF_negclk_sync_reset_vector_bit_en #(
    parameter WIDTH = 8,
    parameter [WIDTH-1:0] RESET_VAL = 8'h34
) (
    input              clk,
    input              reset,
    input  [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);
    reg [WIDTH-1:0] q_reg;

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_ff
            // Per-bit enable: update bit only if reset or d[i] differs from q_reg[i]
            wire bit_ce = reset | (d[i] != q_reg[i]);
            always @(negedge clk) begin
                if (reset)
                    q_reg[i] <= RESET_VAL[i];
                else if (bit_ce)
                    q_reg[i] <= d[i];
                // else retain previous q_reg[i]
            end
        end
    endgenerate

    assign q = q_reg;
endmodule


module TopModule (
    input          clk,
    input          reset,
    input  [7:0]   d,
    output [7:0]   q
);
    DFF_negclk_sync_reset_vector_bit_en #(
        .WIDTH(8),
        .RESET_VAL(8'h34)
    ) reg8_inst (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );
endmodule