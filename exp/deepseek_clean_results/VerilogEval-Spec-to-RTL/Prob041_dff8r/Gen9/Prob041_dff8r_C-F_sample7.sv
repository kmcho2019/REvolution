/**
 * Configurable D Flip-Flop Module with Synchronous Reset
 * 
 * Parameters:
 *   WIDTH - Data width (default: 1)
 * 
 * Ports:
 *   clk   - Clock input (posedge triggered)
 *   reset - Synchronous active-high reset
 *   d     - Data input
 *   q     - Data output
 */
module DFF #(
    parameter WIDTH = 1
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

    // Parameter validation
    initial begin
        if (WIDTH <= 0) begin
            $error("DFF: WIDTH must be positive (given %0d)", WIDTH);
        end
    end

    always @(posedge clk) begin
        if (reset) q <= {WIDTH{1'b0}};  // Synchronous reset to zero
        else q <= d;                    // Normal operation
    end

endmodule

/**
 * Top Module with Configurable DFF Implementation
 * 
 * Parameters:
 *   WIDTH       - Data width (default: 8)
 *   IMPL_STYLE  - Implementation style (0=array, 1=individual)
 * 
 * Ports:
 *   clk   - Clock input
 *   reset - Synchronous reset
 *   d     - 8-bit data input
 *   q     - 8-bit data output
 */
module TopModule #(
    parameter WIDTH = 8,
    parameter IMPL_STYLE = 0  // 0 for array, 1 for individual
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);

    // Parameter validation
    initial begin
        if (WIDTH <= 0) begin
            $error("TopModule: WIDTH must be positive (given %0d)", WIDTH);
        end
        if (IMPL_STYLE != 0 && IMPL_STYLE != 1) begin
            $error("TopModule: IMPL_STYLE must be 0 or 1 (given %0d)", IMPL_STYLE);
        end
    end

    generate
        if (IMPL_STYLE == 0) begin : array_impl
            // Array implementation - better for PPA in most cases
            DFF #(.WIDTH(WIDTH)) dff_array (
                .clk(clk),
                .reset(reset),
                .d(d),
                .q(q)
            );
        end
        else begin : individual_impl
            // Individual implementation - better for debug/control
            genvar i;
            for (i = 0; i < WIDTH; i = i + 1) begin : dff_gen
                DFF #(.WIDTH(1)) dff_inst (
                    .clk(clk),
                    .reset(reset),
                    .d(d[i]),
                    .q(q[i])
                );
            end
        end
    endgenerate

endmodule

/* Example Usage:
// Default configuration (8-bit array implementation)
TopModule dut_default (
    .clk(clk),
    .reset(reset),
    .d(data_in),
    .q(data_out)
);

// Custom configuration (16-bit individual implementation)
TopModule #(.WIDTH(16), .IMPL_STYLE(1)) dut_custom (
    .clk(clk),
    .reset(reset),
    .d(wide_data_in),
    .q(wide_data_out)
);
*/