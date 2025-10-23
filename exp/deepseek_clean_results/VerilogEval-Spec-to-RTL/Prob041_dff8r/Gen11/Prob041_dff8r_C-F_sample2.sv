/**
 * Enhanced Parameterized D Flip-Flop Module
 * Features:
 * - Configurable width (default 1 bit)
 * - Optional synchronous reset (default enabled)
 * - Configurable reset polarity (default active high)
 * - Clean, documented implementation
 */
module DFF #(
    parameter WIDTH = 1,            // Data width
    parameter HAS_RESET = 1,        // Enable reset functionality
    parameter RESET_POLARITY = 1,   // 1=active high, 0=active low
    parameter RESET_VALUE = 0       // Value to reset to
) (
    input clk,                      // Clock input
    input reset,                    // Reset input
    input [WIDTH-1:0] d,            // Data input
    output reg [WIDTH-1:0] q        // Data output
);

// Calculate actual reset value (supports parameterized width)
localparam RESET_VAL = RESET_VALUE ? {WIDTH{1'b1}} : {WIDTH{1'b0}};

always @(posedge clk) begin
    if (HAS_RESET) begin
        if (RESET_POLARITY ? reset : ~reset)
            q <= RESET_VAL;         // Synchronous reset
        else
            q <= d;                 // Normal operation
    end else begin
        q <= d;                     // Operation without reset
    end
end

endmodule

/**
 * Top Module with Enhanced 8-bit Register
 * Features:
 * - Uses parameterized DFF module
 * - Default implementation uses single DFF for optimal PPA
 * - Optional generate-based implementation via parameter
 * - Comprehensive documentation
 */
module TopModule #(
    parameter USE_GENERATE = 0      // 0=single DFF, 1=individual DFFs
) (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

generate
    if (USE_GENERATE) begin: gen_individual
        // Individual flip-flop implementation (better for debug)
        genvar i;
        for (i = 0; i < 8; i = i + 1) begin : dff_gen
            DFF dff_inst (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .q(q[i])
            );
        end
    end else begin: gen_single
        // Single DFF implementation (better for PPA)
        DFF #(.WIDTH(8)) dff_array (
            .clk(clk),
            .reset(reset),
            .d(d),
            .q(q)
        );
    end
endgenerate

endmodule