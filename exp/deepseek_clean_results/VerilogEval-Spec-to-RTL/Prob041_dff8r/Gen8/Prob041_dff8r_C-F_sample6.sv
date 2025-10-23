/**
 * TopModule - 8-bit (configurable) register with synchronous reset
 * Features:
 * - Parameterized width (default 8 bits)
 * - Configurable implementation style
 * - Synchronous active-high reset
 * - Positive edge-triggered
 */
module TopModule #(
    parameter WIDTH = 8,               // Data width
    parameter IMPL_STYLE = "ARRAY"     // "ARRAY" or "INDIVIDUAL"
) (
    input wire clk,                    // Clock input
    input wire reset,                  // Synchronous reset (active high)
    input wire [WIDTH-1:0] d,          // Data input
    output reg [WIDTH-1:0] q           // Data output
);

// Array-style implementation (optimal for PPA)
generate if (IMPL_STYLE == "ARRAY") begin : gen_array
    always @(posedge clk) begin
        if (reset) q <= {WIDTH{1'b0}};
        else q <= d;
    end
end
// Individual-style implementation (better for debug)
else if (IMPL_STYLE == "INDIVIDUAL") begin : gen_individual
    // Internal signals for individual DFFs
    reg [WIDTH-1:0] q_ff;
    
    genvar i;
    for (i = 0; i < WIDTH; i = i + 1) begin : dff_gen
        always @(posedge clk) begin
            if (reset) q_ff[i] <= 1'b0;
            else q_ff[i] <= d[i];
        end
    end
    
    assign q = q_ff;
end
endgenerate

endmodule