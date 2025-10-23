module ROM #(
    parameter PATTERN_MODE = 0,          // 0=ROM mode, 1=Pattern mode
    parameter INIT_FILE = "",            // Optional initialization file
    parameter USE_OUTPUT_REG = 0         // 0=combinational, 1=registered
) (
    input [7:0] addr,
    input clk,                           // Only used if USE_OUTPUT_REG=1
    input power_down,                    // Active-low power control
    output reg [15:0] dout               // Registered if USE_OUTPUT_REG=1
);

    // Memory array (only used in ROM mode)
    reg [15:0] mem [0:255];
    
    // Pattern generation functions
    function [15:0] generate_pattern;
        input [7:0] address;
        begin
            case (PATTERN_MODE)
                1: generate_pattern = {address, address};       // Mirror pattern
                2: generate_pattern = address * 16'h0101;       // Multiplicative
                3: generate_pattern = ~address;                 // Inverted
                default: generate_pattern = 16'h0000;
            endcase
        end
    endfunction

    // Initialization
    initial begin
        if (INIT_FILE != "") begin
            $readmemh(INIT_FILE, mem);
        end else begin
            // Default initialization
            mem[0] = 16'hA0A0;
            mem[1] = 16'hB1B1;
            mem[2] = 16'hC2C2;
            mem[3] = 16'hD3D3;
            for (int i=4; i<256; i++) mem[i] = 16'h0000;
        end
    end

    // Core functionality
    generate
        if (USE_OUTPUT_REG) begin
            // Registered output version
            always @(posedge clk) begin
                if (power_down) begin
                    dout <= 16'h0000;
                end else if (PATTERN_MODE) begin
                    dout <= generate_pattern(addr);
                end else begin
                    dout <= mem[addr];
                end
            end
        end else begin
            // Combinational output version
            always @(*) begin
                if (power_down) begin
                    dout = 16'h0000;
                end else if (PATTERN_MODE) begin
                    dout = generate_pattern(addr);
                end else begin
                    dout = mem[addr];
                end
            end
        end
    endgenerate

    /* Advanced Features:
     * - Pattern modes reduce memory usage for regular data
     * - Power-down mode minimizes dynamic power
     * - Optional output registers improve timing
     * - File-based initialization for large ROMs
     * - Address change detection could be added to minimize switching
     */
endmodule