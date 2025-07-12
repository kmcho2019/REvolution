module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 4'b0000;
    end
    else begin
        // Rotating shift register with special feedback cases
        case (shift_reg)
            4'b0000: shift_reg <= 4'b0001;
            4'b0001: shift_reg <= 4'b0011;
            4'b0011: shift_reg <= 4'b0111;
            4'b0111: shift_reg <= 4'b1111;
            4'b1111: shift_reg <= 4'b1110;
            4'b1110: shift_reg <= 4'b1100;
            4'b1100: shift_reg <= 4'b1000;
            4'b1000: shift_reg <= 4'b0000;
            default: shift_reg <= {shift_reg[2:0], ~shift_reg[3]};
        endcase
    end
end

assign q = shift_reg;

endmodule