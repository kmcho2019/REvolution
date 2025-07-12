module DFF_negclk_sync_reset_vector #(
    parameter WIDTH = 8,
    parameter [WIDTH-1:0] RESET_VAL = 8'h34
) (
    input                  clk,
    input                  reset,
    input  [WIDTH-1:0]     d,
    output [WIDTH-1:0]     q
);
    // Internal registers for each bit
    reg [WIDTH-1:0] q_reg;

    // Generate per-bit negative edge triggered synchronous reset flip-flops
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_ff
            always @(negedge clk) begin
                if (reset)
                    q_reg[i] <= RESET_VAL[i];
                else
                    q_reg[i] <= d[i];
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
    // Instantiate the vectorized per-bit always block DFF with synchronous reset to 0x34
    DFF_negclk_sync_reset_vector #(
        .WIDTH(8),
        .RESET_VAL(8'h34)
    ) reg8_inst (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );
endmodule