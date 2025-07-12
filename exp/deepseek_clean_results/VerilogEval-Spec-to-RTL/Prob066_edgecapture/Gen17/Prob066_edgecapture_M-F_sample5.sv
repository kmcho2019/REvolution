module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    // Registered previous input value
    reg [31:0] prev_in;
    
    // Output register
    reg [31:0] out_reg;
    
    // Falling edge detection
    wire [31:0] falling_edge = prev_in & ~in;
    
    assign out = out_reg;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            out_reg <= 32'b0;
        end else begin
            // Update previous input register
            prev_in <= in;
            
            // Capture falling edges (set corresponding output bits)
            out_reg <= out_reg | falling_edge;
        end
    end

endmodule