module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // Shift register to track first '1' position
    reg [7:0] shift_reg;
    reg invert_flag;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            shift_reg <= 8'b0;
            invert_flag <= 1'b0;
            z <= 1'b0;
        end
        else begin
            // Shift in new bit
            shift_reg <= {shift_reg[6:0], x};
            
            // Set flag when first '1' is detected
            if (!invert_flag && x) begin
                invert_flag <= 1'b1;
            end
            
            // Output logic
            if (invert_flag) begin
                // Invert all bits after first '1'
                z <= ~shift_reg[7];
            end
            else begin
                // Pass through until first '1' is seen
                z <= shift_reg[7];
            end
        end
    end

endmodule