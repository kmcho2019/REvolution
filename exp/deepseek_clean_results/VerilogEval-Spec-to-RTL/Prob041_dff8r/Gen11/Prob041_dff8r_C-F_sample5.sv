/**
 * TopModule - Parameterized Register with Synchronous Reset
 * 
 * Features:
 * - Configurable width (default 8 bits)
 * - Positive edge-triggered D flip-flops
 * - Synchronous active-high reset (sets output to 0)
 * - Two implementation styles (select via parameter)
 *   - SINGLE: Single instance (better PPA)
 *   - GENERATE: Individual flip-flops (better for debug)
 * - Comprehensive documentation and parameter validation
 */

module DFF #(
    parameter WIDTH = 1
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
    always @(posedge clk) begin
        if (reset) q <= {WIDTH{1'b0}};  // Synchronous reset to zero
        else       q <= d;              // Normal operation
    end
endmodule

module TopModule #(
    parameter WIDTH = 8,
    parameter IMPLEMENTATION = "SINGLE"  // "SINGLE" or "GENERATE"
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);

    // Parameter validation
    initial begin
        if (WIDTH < 1) $error("Error: WIDTH must be at least 1");
        if (IMPLEMENTATION != "SINGLE" && IMPLEMENTATION != "GENERATE") begin
            $error("Error: IMPLEMENTATION must be 'SINGLE' or 'GENERATE'");
        end
    end

    // Implementation selection
    generate
        if (IMPLEMENTATION == "SINGLE") begin : single_impl
            // Single instance implementation (optimal PPA)
            DFF #(.WIDTH(WIDTH)) dff_array (
                .clk(clk),
                .reset(reset),
                .d(d),
                .q(q)
            );
        end
        else begin : generate_impl
            // Generate block implementation (debug friendly)
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