module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    // Two-stage pipeline for proper edge detection
    reg [31:0] in_reg;   // current registered input
    reg [31:0] prev_in;  // previous registered input
    
    // Output memory register
    reg [31:0] out_reg;
    
    // Falling edge detection
    wire [31:0] falling_edge;
    
    assign falling_edge = prev_in & ~in_reg;
    assign out = out_reg;

    always @(posedge clk) begin
        if (reset) begin
            in_reg <= 32'b0;
            prev_in <= 32'b0;
            out_reg <= 32'b0;
        end else begin
            // Update pipeline registers
            prev_in <= in_reg;
            in_reg <= in;
            
            // Capture and hold falling edges
            out_reg <= out_reg | falling_edge;
        end
    end

endmodule