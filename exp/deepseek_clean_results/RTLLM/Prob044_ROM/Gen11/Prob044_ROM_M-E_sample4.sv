module ROM #(
    parameter WIDTH = 16,        // Data width
    parameter DEPTH = 256,       // Memory depth
    parameter PATTERN = 0,       // Initialization pattern
    parameter CLOCK_GATED = 1    // Enable clock gating
)(
    input clk,                   // Clock (for gated version)
    input en,                    // Enable signal
    input [7:0] addr,            // Address input
    output reg [WIDTH-1:0] dout, // Data output
    output reg error             // Address error flag
);

    // Memory array declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Clock gating signals
    wire gated_clk;
    generate if (CLOCK_GATED) begin
        assign gated_clk = clk & en;
    end else begin
        assign gated_clk = clk;
    end endgenerate

    // Function for pattern generation
    function [WIDTH-1:0] init_pattern;
        input [7:0] addr;
        case (PATTERN)
            0: init_pattern = {addr, addr};           // Mirror pattern
            1: init_pattern = addr * 16'h0101;        // Multiplicative
            2: init_pattern = ~addr;                  // Inverted
            3: init_pattern = {WIDTH{1'b1}} - addr;   // Descending
            default: init_pattern = addr;             // Linear
        endcase
    endfunction

    // Memory initialization
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            mem[i] = init_pattern(i[7:0]);
        end
    end

    // Error detection for out-of-range addresses
    always @(*) begin
        error = (addr >= DEPTH);
    end

    // Registered output with clock gating
    always @(posedge gated_clk) begin
        if (!error) begin
            dout <= mem[addr];
        end else begin
            dout <= {WIDTH{1'b0}};
        end
    end

    /* Configuration Guide:
     * PATTERN Options:
     *   0 - Mirror pattern (AABB)
     *   1 - Multiplicative pattern
     *   2 - Inverted pattern
     *   3 - Descending pattern
     *   Other - Linear pattern
     *
     * Power Optimization:
     * - Set CLOCK_GATED=1 to enable clock gating
     * - Use 'en' signal to disable when not in use
     *
     * Error Handling:
     * - 'error' flag indicates invalid addresses
     * - Outputs zero on error
     */
endmodule