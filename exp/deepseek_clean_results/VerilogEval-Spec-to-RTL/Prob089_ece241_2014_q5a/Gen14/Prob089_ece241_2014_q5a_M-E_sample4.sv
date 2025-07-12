module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg [7:0] shift_reg;  // Tracks position of first '1'
    reg found_one;        // Flag indicating first '1' found
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            shift_reg <= 8'b0;
            found_one <= 1'b0;
            z <= 1'b0;
        end else begin
            // Shift in new bit and track first '1' position
            shift_reg <= {shift_reg[6:0], x};
            
            // Update found_one flag
            if (!found_one && x) begin
                found_one <= 1'b1;
            end
            
            // Output logic
            if (!found_one) begin
                z <= x;  // Pass through until first '1'
            end else begin
                z <= ~x; // Invert after first '1'
            end
        end
    end

endmodule