module TopModule(
    input  [2:0] y,
    input  w,
    output Y1
);

    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    reg next_y1;

    always @(*) begin
        case (y)
            3'b000: next_y1 = 1'b0;   // A
            3'b001: next_y1 = 1'b1;   // B
            3'b010: next_y1 = w;      // C
            3'b011: next_y1 = 1'b0;   // D
            3'b100: next_y1 = w;      // E
            3'b101: next_y1 = 1'b1;   // F
            default: next_y1 = 1'b0;  // Default safe
        endcase
    end

    assign Y1 = y1;

endmodule