module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] in_prev;
    reg [31:0] out_reg;
    
    // Falling edge detection between current and previous cycle
    wire [31:0] falling_edge = in_prev & ~in;
    
    // Output is directly assigned from the register
    assign out = out_reg;
    
    always @(posedge clk) begin
        if (reset) begin
            in_prev <= 32'b0;
            out_reg <= 32'b0;
        end
        else begin
            in_prev <= in;
            out_reg <= out_reg | falling_edge;
        end
    end

endmodule