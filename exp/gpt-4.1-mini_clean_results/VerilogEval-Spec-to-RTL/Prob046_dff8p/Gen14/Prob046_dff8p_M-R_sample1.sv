module DFF_negclk_sync_reset_vector_bit_en #(
    parameter WIDTH = 8,
    parameter [WIDTH-1:0] RESET_VAL = 8'h34
) (
    input              clk,
    input              reset,
    input  [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

    integer i;
    always @(negedge clk) begin
        if (reset) begin
            q <= RESET_VAL;
        end else begin
            for (i = 0; i < WIDTH; i = i + 1) begin
                // Update bit only if input differs from stored bit to save toggling
                if (d[i] != q[i])
                    q[i] <= d[i];
                // else retain previous q[i]
            end
        end
    end

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