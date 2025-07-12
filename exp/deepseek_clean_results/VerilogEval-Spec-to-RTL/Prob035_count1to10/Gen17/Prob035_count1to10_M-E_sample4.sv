module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [9:0] shift_reg;
wire [9:0] next_shift;

// Shift register with circular feedback
assign next_shift = reset ? 10'b0000000001 : 
                   {shift_reg[8:0], shift_reg[9]};

// Binary encoder for shift register position
always @(*) begin
    case (1'b1)
        shift_reg[0]: q = 4'b0001;
        shift_reg[1]: q = 4'b0010;
        shift_reg[2]: q = 4'b0011;
        shift_reg[3]: q = 4'b0100;
        shift_reg[4]: q = 4'b0101;
        shift_reg[5]: q = 4'b0110;
        shift_reg[6]: q = 4'b0111;
        shift_reg[7]: q = 4'b1000;
        shift_reg[8]: q = 4'b1001;
        shift_reg[9]: q = 4'b1010;
        default: q = 4'b0001;
    endcase
end

always @(posedge clk) begin
    shift_reg <= next_shift;
end

endmodule