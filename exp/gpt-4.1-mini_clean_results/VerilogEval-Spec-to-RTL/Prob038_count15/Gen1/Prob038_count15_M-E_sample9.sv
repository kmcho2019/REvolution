module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

reg [3:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 4'b0001;
        q <= 4'b0000;
    end else begin
        // Rotate the '1' in shift_reg left by 1
        shift_reg <= {shift_reg[2:0], shift_reg[3]};
        // Decode position of '1' in shift_reg to binary count (0 to 15)
        case (shift_reg)
            4'b0001: q <= 4'd0;
            4'b0010: q <= 4'd1;
            4'b0100: q <= 4'd2;
            4'b1000: q <= 4'd3;
            default: q <= q + 1'b1; // fallback in case of invalid shift_reg
        endcase
    end
end

endmodule