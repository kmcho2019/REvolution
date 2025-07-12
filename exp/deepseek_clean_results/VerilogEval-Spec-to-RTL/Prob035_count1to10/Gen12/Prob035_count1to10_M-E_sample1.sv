module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [9:0] shift_reg;  // One-hot shift register (bits 0-9 represent counts 1-10)

// Sequential shift register update
always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 10'b0000000001;  // Reset to count=1 (bit 0 is '1')
    end else begin
        // Circular shift with wrap-around
        shift_reg <= {shift_reg[8:0], shift_reg[9]};
    end
end

// Combinational output encoder
always @(*) begin
    case (shift_reg)
        10'b0000000001: q = 4'b0001;  // 1
        10'b0000000010: q = 4'b0010;  // 2
        10'b0000000100: q = 4'b0011;  // 3
        10'b0000001000: q = 4'b0100;  // 4
        10'b0000010000: q = 4'b0101;  // 5
        10'b0000100000: q = 4'b0110;  // 6
        10'b0001000000: q = 4'b0111;  // 7
        10'b0010000000: q = 4'b1000;  // 8
        10'b0100000000: q = 4'b1001;  // 9
        10'b1000000000: q = 4'b1010;  // 10
        default:        q = 4'b0001;  // Should never occur
    endcase
end

endmodule