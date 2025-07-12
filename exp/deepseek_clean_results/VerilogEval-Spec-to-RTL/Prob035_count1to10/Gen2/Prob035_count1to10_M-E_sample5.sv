module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [9:0] shift_reg;

// One-hot to binary encoder
assign q = (shift_reg[0]) ? 4'b0001 :
           (shift_reg[1]) ? 4'b0010 :
           (shift_reg[2]) ? 4'b0011 :
           (shift_reg[3]) ? 4'b0100 :
           (shift_reg[4]) ? 4'b0101 :
           (shift_reg[5]) ? 4'b0110 :
           (shift_reg[6]) ? 4'b0111 :
           (shift_reg[7]) ? 4'b1000 :
           (shift_reg[8]) ? 4'b1001 :
                           4'b1010;  // shift_reg[9]

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 10'b0000000001;  // Reset to count=1 (first bit set)
    end
    else begin
        // Circular left shift
        shift_reg <= {shift_reg[8:0], shift_reg[9]};
    end
end

endmodule