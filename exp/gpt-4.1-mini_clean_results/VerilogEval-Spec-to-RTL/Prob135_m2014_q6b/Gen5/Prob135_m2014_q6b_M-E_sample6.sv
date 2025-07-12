module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    reg next_y1;

    always @(*) begin
        case (y)
            3'b000: next_y1 = 0;                // A(000) -> next y's bit1: 000 or 000 (A or B), y1=0
            3'b001: next_y1 = w ? 1'b1 : 1'b0; // B(001) -> next is D(011) if w=1 else C(010), y1=D=1 or C=1
            3'b010: next_y1 = w ? 1'b1 : 1'b0; // C(010) -> next is D(011) if w=1 else E(100), y1=D=1 or E=0
            3'b011: next_y1 = w ? 1'b0 : 1'b0; // D(011) -> next is A(000) if w=1 else F(101), y1=0 or 0
            3'b100: next_y1 = 1'b1;             // E(100) -> next is D(011) or E(100), both y1=1 or 1
            3'b101: next_y1 = w ? 1'b1 : 1'b0; // F(101) -> next is D(011) if w=1 else C(010), y1=1 or 1 (D=1, C=1)
            default: next_y1 = 1'b0;
        endcase
    end

    assign Y1 = next_y1;

endmodule