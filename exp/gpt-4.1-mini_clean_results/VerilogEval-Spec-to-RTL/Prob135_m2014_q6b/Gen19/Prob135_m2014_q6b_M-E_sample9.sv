module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);
    reg next_y1;

    always @(*) begin
        case (y)
            3'b000: next_y1 = 1'b0;        // A(000): next A or B, middle bit 0
            3'b001: next_y1 = w ? 1'b1 : 1'b0; // B(001): if w=0->C(010), y[1]=1; if w=1->D(011), y[1]=1
            3'b010: next_y1 = 1'b1;        // C(010): next E or D, middle bit 1
            3'b011: next_y1 = w ? 1'b0 : 1'b0; // D(011): next A or F, both y[1]=0
            3'b100: next_y1 = 1'b1;        // E(100): next E or D, y[1]=1 or 1
            3'b101: next_y1 = w ? 1'b1 : 1'b0; // F(101): next D or C, y[1]=1 or 1
            default: next_y1 = 1'b0;
        endcase
    end

    assign Y1 = next_y1;

endmodule