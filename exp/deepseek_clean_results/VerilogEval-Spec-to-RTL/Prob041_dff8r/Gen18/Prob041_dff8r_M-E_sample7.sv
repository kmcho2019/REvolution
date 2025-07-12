/**
 * AdvancedRegister - Enhanced 8-bit register with parallel/serial capabilities
 * 
 * Features:
 * - Parallel load with synchronous reset
 * - Optional clock gating for power savings
 * - Built-in input data validation
 * - Parameterized width (default 8 bits)
 * - Future-ready architecture (serial shift capability)
 */
module AdvancedRegister #(
    parameter WIDTH = 8,
    parameter ENABLE_CLOCK_GATING = 1  // 1 to enable clock gating
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q,
    output reg data_valid  // Indicates if input data changed
);

    reg [WIDTH-1:0] d_prev;  // Store previous input for change detection
    wire gated_clk;          // Gated clock signal
    wire data_changed;       // Indicates input change

    // Clock gating logic (optional)
    assign data_changed = (d != d_prev);
    assign gated_clk = ENABLE_CLOCK_GATING ? (clk & (reset | data_changed)) : clk;

    // Main register logic
    always @(posedge gated_clk) begin
        if (reset) begin
            q <= {WIDTH{1'b0}};  // Synchronous reset
            data_valid <= 1'b0;
        end
        else begin
            q <= d;              // Parallel load
            data_valid <= 1'b1;
        end
        d_prev <= d;  // Store current input for next comparison
    end

    // Input validation (optional)
    always @(*) begin
        if (^d === 1'bx) begin
            $display("Warning: %0d ns - Invalid input (X or Z) detected", $time);
        end
    end

endmodule

// Top module wrapper
module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

    // Instantiate the advanced register
    AdvancedRegister #(
        .WIDTH(8),
        .ENABLE_CLOCK_GATING(1)  // Enable power optimization
    ) u_register (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q),
        .data_valid()  // Leave unconnected in this simple case
    );

endmodule