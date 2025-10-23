module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [9:0] shift_reg;

// Shift register counter (one-hot)
always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 10'b0000000001;  // Reset to 0 (LSB=1)
    end
    else begin
        // Circular shift left with reset at count=9
        if (shift_reg[9]) begin
            shift_reg <= 10'b0000000001;
        end
        else begin
            shift_reg <= {shift_reg[8:0], 1'b0};
        end
    end
end

// One-hot to binary decoder
assign q = (shift_reg[0] ? 4'b0000 :
            shift_reg[1] ? 4'b0001 :
            shift_reg[2] ? 4'b0010 :
            shift_reg[3] ? 4'b0011 :
            shift_reg[4] ? 4'b0100 :
            shift_reg[5] ? 4'b0101 :
            shift_reg[6] ? 4'b0110 :
            shift_reg[7] ? 4'b0111 :
            shift_reg[8] ? 4'b1000 :
            shift_reg[9] ? 4'b1001 :
            4'b0000;

endmodule