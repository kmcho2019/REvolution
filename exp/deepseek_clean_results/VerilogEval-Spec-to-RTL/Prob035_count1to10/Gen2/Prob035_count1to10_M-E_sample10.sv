module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [9:0] shift_reg;  // One-hot encoded counter (positions 0-9 represent 1-10)

// Simple encoder to convert one-hot to binary
assign q = shift_reg[0] ? 4'b0001 :  // 1
            shift_reg[1] ? 4'b0010 :  // 2
            shift_reg[2] ? 4'b0011 :  // 3
            shift_reg[3] ? 4'b0100 :  // 4
            shift_reg[4] ? 4'b0101 :  // 5
            shift_reg[5] ? 4'b0110 :  // 6
            shift_reg[6] ? 4'b0111 :  // 7
            shift_reg[7] ? 4'b1000 :  // 8
            shift_reg[8] ? 4'b1001 :  // 9
                           4'b1010;   // 10

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 10'b0000000001;  // Reset to position 0 (value 1)
    end
    else begin
        // Circular shift left
        shift_reg <= {shift_reg[8:0], shift_reg[9]};
    end
end

endmodule