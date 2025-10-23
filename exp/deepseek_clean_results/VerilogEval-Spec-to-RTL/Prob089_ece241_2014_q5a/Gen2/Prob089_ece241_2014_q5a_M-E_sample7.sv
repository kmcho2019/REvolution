module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg seen_one;
    reg [7:0] shift_reg;  // Buffer for input bits
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            seen_one <= 1'b0;
            shift_reg <= 8'b0;
            z <= 1'b0;
        end else begin
            // Shift in new bit
            shift_reg <= {x, shift_reg[7:1]};
            
            // Update seen_one flag
            if (!seen_one && x) begin
                seen_one <= 1'b1;
            end
            
            // Output logic
            if (seen_one) begin
                z <= ~shift_reg[0];  // Complement oldest bit
            end else begin
                z <= shift_reg[0];   // Pass through oldest bit
            end
        end
    end

endmodule