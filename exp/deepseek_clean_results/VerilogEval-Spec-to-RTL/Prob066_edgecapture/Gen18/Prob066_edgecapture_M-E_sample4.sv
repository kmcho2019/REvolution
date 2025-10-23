module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    // Two-stage pipeline registers
    reg [31:0] stage1, stage2;
    
    // Output register
    reg [31:0] out_reg;
    
    // Falling edge detection (1→1→0 pattern)
    wire [31:0] falling_edge = stage2 & stage1 & ~in;
    
    assign out = out_reg;

    always @(posedge clk) begin
        if (reset) begin
            stage1 <= 32'b0;
            stage2 <= 32'b0;
            out_reg <= 32'b0;
        end else begin
            // Update pipeline registers
            stage1 <= in;
            stage2 <= stage1;
            
            // Capture falling edges (set corresponding output bits)
            out_reg <= out_reg | falling_edge;
        end
    end

endmodule