/* 
 * TopModule - 8-bit register with synchronous reset
 * Features:
 * - Parameterized width (default 8 bits)
 * - Synchronous active-high reset
 * - Positive edge-triggered flip-flops
 * - Configurable implementation style
 * - Optional clock gating (disabled by default)
 */
module TopModule #(
    parameter WIDTH = 8,                    // Data width
    parameter IMPLEMENTATION = "ARRAY",     // "ARRAY" or "INDIVIDUAL"
    parameter CLOCK_GATING = 0              // Enable clock gating (0/1)
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);

// Optional clock gating logic
wire gated_clk;
generate
    if (CLOCK_GATING) begin : gen_clk_gate
        // Simple clock gating when data isn't changing
        reg [WIDTH-1:0] prev_d;
        wire clk_enable = (prev_d != d);
        
        always @(posedge clk) begin
            if (reset) prev_d <= {WIDTH{1'b0}};
            else prev_d <= d;
        end
        
        assign gated_clk = clk & clk_enable;
    end else begin : gen_no_clk_gate
        assign gated_clk = clk;
    end
endgenerate

// Main register implementation
generate
    if (IMPLEMENTATION == "ARRAY") begin : gen_array_impl
        // Single always block implementation (optimal for PPA)
        reg [WIDTH-1:0] q_reg;
        
        always @(posedge gated_clk) begin
            if (reset) q_reg <= {WIDTH{1'b0}};
            else q_reg <= d;
        end
        
        assign q = q_reg;
    end
    else begin : gen_individual_impl
        // Individual flip-flop instances (better for debug)
        reg [WIDTH-1:0] q_reg;
        
        always @(posedge gated_clk) begin
            for (int i = 0; i < WIDTH; i = i + 1) begin
                if (reset) q_reg[i] <= 1'b0;
                else q_reg[i] <= d[i];
            end
        end
        
        assign q = q_reg;
    end
endgenerate

/* Alternative modular implementation (commented out)
// DFF #(.WIDTH(WIDTH)) dff_inst (
//     .clk(gated_clk),
//     .reset(reset),
//     .d(d),
//     .q(q)
// );
*/

endmodule

/* 
 * Parameterized D flip-flop module (optional)
 * Kept separate for potential reuse in other designs
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
    if (reset) q <= {WIDTH{1'b0}};
    else q <= d;
end

endmodule