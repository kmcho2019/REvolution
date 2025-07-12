module TopModule #(
    parameter DELAY_CYCLES = 1  // Configurable delay for sequential output
)(
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output wire out_always_comb,
    output reg  out_always_ff,
    // Scan chain interface for testability
    input  wire scan_in,
    input  wire scan_en,
    output wire scan_out,
    // Asynchronous reset
    input  wire rst_n
);

    // Basic XOR implementations (unchanged)
    assign out_assign = a ^ b;
    assign out_always_comb = a ^ b;

    // Scan chain register
    reg scan_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            scan_reg <= 1'b0;
        end else if (scan_en) begin
            scan_reg <= scan_in;
        end
    end
    assign scan_out = scan_reg;

    // Enhanced sequential output with configurable delay
    reg [DELAY_CYCLES-1:0] delay_chain;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            delay_chain <= {DELAY_CYCLES{1'b0}};
            out_always_ff <= 1'b0;
        end else begin
            delay_chain <= {delay_chain[DELAY_CYCLES-2:0], (a ^ b)};
            out_always_ff <= delay_chain[DELAY_CYCLES-1];
        end
    end

endmodule