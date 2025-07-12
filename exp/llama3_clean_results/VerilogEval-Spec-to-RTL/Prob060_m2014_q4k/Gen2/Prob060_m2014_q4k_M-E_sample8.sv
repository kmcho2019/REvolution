module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] shift_reg;
reg [1:0] shift_pos;

always @(posedge clk) begin
    if (~resetn) begin
        shift_reg <= 4'b0000;
        shift_pos <= 2'b00;
    end else begin
        case (shift_pos)
            2'b00: shift_reg <= {in, shift_reg[3:1]};
            2'b01: shift_reg <= {shift_reg[2:0], in};
            2'b10: shift_reg <= {shift_reg[1:0], in, shift_reg[3]};
            2'b11: shift_reg <= {in, shift_reg[3:2], shift_reg[0]};
        endcase
        shift_pos <= shift_pos + 1'b1;
        if (shift_pos == 2'b11) begin
            shift_pos <= 2'b00;
        end
    end
end

assign out = shift_reg[0];

endmodule