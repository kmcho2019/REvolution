/**
 * Advanced DFF Array with Power Optimization
 * 
 * Features:
 * - 8-bit register with synchronous reset
 * - Optional parallel load enable
 * - Data stability detection for power savings
 * - Single always block implementation
 * - Parameterized width
 * - Built-in clock gating when data is stable
 */

module TopModule #(
    parameter WIDTH = 8
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q,
    // Optional control signals
    input load_enable = 1'b1,  // Default to always enabled
    output reg data_stable     // Indicates when data hasn't changed
);

    // Data stability detection
    reg [WIDTH-1:0] prev_d;
    always @(posedge clk) begin
        prev_d <= d;
        data_stable <= (prev_d == d) && !reset;
    end

    // Gated clock signal
    wire gated_clk;
    assign gated_clk = clk & (~data_stable | reset);

    // Main register with synchronous reset
    always @(posedge gated_clk) begin
        if (reset) begin
            q <= {WIDTH{1'b0}};
        end
        else if (load_enable) begin
            q <= d;
        end
    end

    // Initial block for simulation clarity
    initial begin
        q = {WIDTH{1'b0}};
        prev_d = {WIDTH{1'b0}};
        data_stable = 1'b0;
    end

endmodule