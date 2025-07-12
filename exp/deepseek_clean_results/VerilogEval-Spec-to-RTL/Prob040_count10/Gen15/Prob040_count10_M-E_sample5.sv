module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [9:0] shift_reg;

// One-hot to binary encoder
always @(*) begin
    case (shift_reg)
        10'b0000000001: q = 4'b0000;
        10'b0000000010: q = 4'b0001;
        10'b0000000100: q = 4'b0010;
        10'b0000001000: q = 4'b0011;
        10'b0000010000: q = 4'b0100;
        10'b0000100000: q = 4'b0101;
        10'b0001000000: q = 4'b0110;
        10'b0010000000: q = 4'b0111;
        10'b0100000000: q = 4'b1000;
        10'b1000000000: q = 4'b1001;
        default: q = 4'b0000;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 10'b0000000001;  // Reset to position 0
    end else begin
        // Circular shift with wrap-around
        shift_reg <= {shift_reg[8:0], shift_reg[9]};
    end
end

endmodule