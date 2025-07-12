/**
 * TopModule - Parameterized Register with Synchronous Reset
 * 
 * Features:
 * - Fully parameterized width (default 8 bits)
 * - Positive edge-triggered D flip-flops
 * - Synchronous active-high reset (configurable reset value)
 * - Multiple implementation styles (select via parameter)
 * - Comprehensive documentation and parameter validation
 * - Optimal PPA characteristics by default
 */

// Parameterized D flip-flop with synchronous reset
module DFF #(
    parameter WIDTH = 1,
    parameter RESET_VAL = 0
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

    // Reset value expansion
    localparam RESET_VECTOR = {WIDTH{RESET_VAL[0]}};

    always @(posedge clk) begin
        if (reset) q <= RESET_VECTOR;  // Synchronous reset
        else       q <= d;             // Normal operation
    end

endmodule

// Top module with configurable implementation
module TopModule #(
    parameter WIDTH = 8,               // Register width
    parameter IMPL_STYLE = "SINGLE",   // "SINGLE" or "GENERATE"
    parameter RESET_VAL = 0            // Reset value (0 or 1)
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);

    // Parameter validation
    initial begin
        if (WIDTH < 1) 
            $error("Error: WIDTH must be at least 1 (given %0d)", WIDTH);
        if (!(IMPL_STYLE inside {"SINGLE", "GENERATE"}))
            $error("Error: IMPL_STYLE must be SINGLE or GENERATE");
        if (RESET_VAL != 0 && RESET_VAL != 1)
            $error("Error: RESET_VAL must be 0 or 1");
    end

    // Implementation selection
    generate
        if (IMPL_STYLE == "SINGLE") begin : single_impl
            // Single instance implementation (optimal PPA)
            DFF #(
                .WIDTH(WIDTH),
                .RESET_VAL(RESET_VAL)
            ) dff_array (
                .clk(clk),
                .reset(reset),
                .d(d),
                .q(q)
            );
        end
        else begin : generate_impl
            // Generate block implementation (for debugging)
            genvar i;
            for (i = 0; i < WIDTH; i = i + 1) begin : dff_gen
                DFF #(
                    .WIDTH(1),
                    .RESET_VAL(RESET_VAL)
                ) dff_inst (
                    .clk(clk),
                    .reset(reset),
                    .d(d[i]),
                    .q(q[i])
                );
            end
        end
    endgenerate

endmodule