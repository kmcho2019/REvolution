module TopModule(
    input  clk,
    input  load,
    input  ena,
    input  [1:0] amount,
    input  [63:0] data,
    output [63:0] q
);

reg [63:0] shift_reg;

always @(posedge clk) begin
    if (load) begin
        shift_reg <= data;
    end else if (ena) begin
        case (amount)
            2'b00: shift_reg <= {shift_reg[62:0], 1'b0}; // shift left by 1 bit
            2'b01: shift_reg <= {shift_reg[55:0], 8'b0}; // shift left by 8 bits
            2'b10: begin // shift right by 1 bit, arithmetic right shift
                if (shift_reg[63]) begin
                    shift_reg <= {1'b1, shift_reg[63:1]};
                end else begin
                    shift_reg <= {1'b0, shift_reg[63:1]};
                end
            end
            2'b11: begin // shift right by 8 bits, arithmetic right shift
                if (shift_reg[63]) begin
                    shift_reg <= {{8{1'b1}}, shift_reg[63:8]};
                end else begin
                    shift_reg <= {{8{1'b0}}, shift_reg[63:8]};
                end
            end
        endcase
    end
end

assign q = shift_reg;

endmodule