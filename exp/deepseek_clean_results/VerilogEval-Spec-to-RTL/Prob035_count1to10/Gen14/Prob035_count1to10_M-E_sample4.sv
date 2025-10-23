module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [9:0] shift_reg;  // One-hot shift register (bits 0-9 represent 1-10)

// Shift register logic
always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 10'b0000000001;  // Reset to 1 (bit 0 set)
    end
    else begin
        // Circular shift with wrap-around from bit 9 to bit 0
        shift_reg <= {shift_reg[8:0], shift_reg[9]};
    end
end

// Output encoding (one-hot to binary)
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
        default:     q = 4'b0001;   // Default to 1 (should never occur)
    endcase
end

endmodule