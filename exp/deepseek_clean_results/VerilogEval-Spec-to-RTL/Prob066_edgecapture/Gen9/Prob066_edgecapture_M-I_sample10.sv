module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] in_reg;      // Current cycle registered input
    reg [31:0] prev_in_reg; // Previous cycle registered input
    reg [31:0] captured_reg;
    
    // Falling edge detection (combinational)
    wire [31:0] falling_edge = prev_in_reg & ~in_reg;
    
    // Output assignment
    assign out = captured_reg;

    always @(posedge clk) begin
        if (reset) begin
            in_reg <= 32'b0;
            prev_in_reg <= 32'b0;
            captured_reg <= 32'b0;
        end
        else begin
            // Two-stage pipeline for proper edge detection
            prev_in_reg <= in_reg;
            in_reg <= in;
            
            // Update captured bits (sticky until reset)
            captured_reg <= captured_reg | falling_edge;
        end
    end

endmodule