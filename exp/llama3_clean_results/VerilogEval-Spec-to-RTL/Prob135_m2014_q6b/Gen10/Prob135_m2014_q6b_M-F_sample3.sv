module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    reg next_y1;

    always @(*) begin
        case ({y[2:0]})
            3'b000: next_y1 = ~w; // A
            3'b001: next_y1 = w ? 1'b1 : 1'b1; // B
            3'b010: next_y1 = w ? 1'b1 : 1'b0; // C
            3'b011: next_y1 = ~w ? 1'b1 : 1'b0; // D
            3'b100: next_y1 = w ? 1'b1 : 1'b0; // E
            3'b101: next_y1 = w ? 1'b1 : 1'b1; // F
            default: next_y1 = 1'b0;
        endcase
    end

    assign Y1 = y[1];

endmodule