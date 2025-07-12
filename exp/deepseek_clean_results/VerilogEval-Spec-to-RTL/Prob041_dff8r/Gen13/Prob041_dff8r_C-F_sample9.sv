/**
 * Parameterized D Flip-Flop with Synchronous Reset
 * @param DATA_WIDTH Data width (default = 8 bits)
 * @input clk       Clock signal
 * @input reset     Active-high synchronous reset
 * @input d         Data input
 * @output q        Data output
 * @note Reset clears all bits to 0 synchronously on rising clock edge
 */
module DFF #(
    parameter DATA_WIDTH = 8
) (
    input clk,
    input reset,
    input [DATA_WIDTH-1:0] d,
    output reg [DATA_WIDTH-1:0] q
);

always @(posedge clk) begin
    if (reset) q <= {DATA_WIDTH{1'b0}};  // Synchronous reset to zero
    else      q <= d;                   // Normal operation
end

endmodule

/**
 * Top Module with 8-bit Register
 * @param USE_ARRAY_DFF (1 = single DFF array, 0 = individual FFs)
 * @input clk   Clock signal
 * @input reset Active-high synchronous reset
 * @input d     8-bit data input
 * @output q    8-bit data output
 * @note Default implementation uses single DFF array for optimal PPA
 */
module TopModule #(
    parameter USE_ARRAY_DFF = 1
) (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

generate
    if (USE_ARRAY_DFF) begin : array_dff
        // Single DFF array implementation (optimal PPA)
        DFF dff_array (
            .clk(clk),
            .reset(reset),
            .d(d),
            .q(q)
        );
    end
    else begin : individual_dffs
        // Individual flip-flop implementation
        genvar i;
        for (i = 0; i < 8; i = i + 1) begin : dff_gen
            DFF #(.DATA_WIDTH(1)) dff_inst (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .q(q[i])
            );
        end
    end
endgenerate

endmodule