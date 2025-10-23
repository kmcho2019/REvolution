module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    // Parameterized width (fixed to 4 for this problem)
    parameter WIDTH = 4;
    
    // Shift register vector
    reg [WIDTH-1:0] shift_reg;
    
    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= {WIDTH{1'b0}};  // Clear all bits on reset
        end else begin
            shift_reg <= {shift_reg[WIDTH-2:0], in};  // Shift operation
        end
    end
    
    // Output is the last bit of the shift register
    assign out = shift_reg[WIDTH-1];

endmodule