module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [9:0] shift_reg;  // 10-bit shift register representing states 1-10

always @(posedge clk) begin
    if (reset) begin
        // Initialize shift register with only the first bit set (representing count=1)
        shift_reg <= 10'b0000000001;
    end
    else begin
        // Rotate the shift register left by 1 position
        shift_reg <= {shift_reg[8:0], shift_reg[9]};
    end
end

// Combinatorial logic to convert shift register state to binary output
always @(*) begin
    case (1'b1)
        shift_reg[0]: q = 4'b0001;  // 1
        shift_reg[1]: q = 4'b0010;  // 2
        shift_reg[2]: q = 4'b0011;  // 3
        shift_reg[3]: q = 4'b0100;  // 4
        shift_reg[4]: q = 4'b0101;  // 5
        shift_reg[5]: q = 4'b0110;  // 6
        shift_reg[6]: q = 4'b0111;  // 7
        shift_reg[7]: q = 4'b1000;  // 8
        shift_reg[8]: q = 4'b1001;  // 9
        shift_reg[9]: q = 4'b1010;  // 10
        default: q = 4'b0001;       // Default to 1 (should never occur)
    endcase
end

endmodule