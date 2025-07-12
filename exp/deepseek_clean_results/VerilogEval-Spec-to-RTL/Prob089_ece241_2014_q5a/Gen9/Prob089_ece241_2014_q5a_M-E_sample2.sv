module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg seen_one;
    reg [63:0] shift_reg;  // Large enough for practical purposes
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            seen_one <= 1'b0;
            shift_reg <= 64'b0;
            z <= 1'b0;
        end
        else begin
            // Shift in new bit
            shift_reg <= {x, shift_reg[63:1]};
            
            // Update seen_one flag
            if (!seen_one && x) begin
                seen_one <= 1'b1;
            end
            
            // Output logic
            z <= seen_one ? ~x : x;
        end
    end

endmodule