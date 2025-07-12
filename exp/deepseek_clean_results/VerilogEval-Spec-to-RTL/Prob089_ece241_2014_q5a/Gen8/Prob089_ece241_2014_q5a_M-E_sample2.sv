module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg flag;
    reg [1:0] shift_reg;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            flag <= 1'b0;
            shift_reg <= 2'b00;
        end else begin
            // Update shift register
            shift_reg <= {shift_reg[0], x};
            
            // Set flag when first '1' is seen in input
            if (x && !flag) begin
                flag <= 1'b1;
            end
            
            // Propagate flag through shift register
            if (shift_reg[1] && flag) begin
                flag <= 1'b1;
            end
        end
    end
    
    // Output is XOR of input with flag (copies when flag=0, inverts when flag=1)
    assign z = x ^ flag;

endmodule