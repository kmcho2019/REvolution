module TopModule(
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    reg next_y1_reg;

    always @(*) begin
        case (y)
            3'b001: next_y1_reg = 1'b1; // B
            3'b010: next_y1_reg = w;     // C
            3'b100: next_y1_reg = w;     // E
            3'b101: next_y1_reg = 1'b1; // F
            default: next_y1_reg = 1'b0; // A or D or others
        endcase
    end

    assign Y1 = next_y1_reg;

endmodule