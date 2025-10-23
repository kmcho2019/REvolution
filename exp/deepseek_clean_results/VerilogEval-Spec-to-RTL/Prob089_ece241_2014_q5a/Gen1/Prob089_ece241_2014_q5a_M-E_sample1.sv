module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg flip_flag;
    reg [7:0] shift_reg;  // Buffer for processing
    reg [2:0] ptr;        // Pointer for output selection
    reg [2:0] count;      // Bit counter

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            flip_flag <= 0;
            shift_reg <= 8'b0;
            ptr <= 0;
            count <= 0;
        end else begin
            // Shift in new bit
            shift_reg <= {shift_reg[6:0], x};
            
            // Set flip_flag when first '1' is seen
            if (!flip_flag && x) begin
                flip_flag <= 1;
            end
            
            // Update counters
            if (count < 7) begin
                count <= count + 1;
            end
            ptr <= count;  // Output follows input with 1 cycle delay
        end
    end

    // Output logic: invert if flip_flag is set and we're past the first '1'
    assign z = flip_flag ? ~shift_reg[ptr] : shift_reg[ptr];

endmodule