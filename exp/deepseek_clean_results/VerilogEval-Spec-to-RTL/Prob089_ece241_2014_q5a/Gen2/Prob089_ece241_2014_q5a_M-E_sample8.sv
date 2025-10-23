module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg [7:0] shift_reg;  // 8-bit shift register (can be sized as needed)
    reg [2:0] counter;    // Tracks position of first '1'
    reg found_one;        // Flag indicating first '1' found
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            shift_reg <= 8'b0;
            counter <= 3'b0;
            found_one <= 1'b0;
        end
        else begin
            shift_reg <= {x, shift_reg[7:1]};  // Shift in new bit
            
            if (!found_one && x) begin
                found_one <= 1'b1;
                counter <= 3'b0;
            end
            else if (!found_one) begin
                counter <= counter + 1;
            end
        end
    end

    // Output logic
    assign z = found_one ? ~shift_reg[0] : shift_reg[0];

endmodule