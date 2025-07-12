module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    reg next_y1;
    assign Y1 = y[1];

    always @(*) begin
        case (y)
            3'b000: next_y1 = 1'b0;  // State A: next y[1] always 0
            3'b001: next_y1 = 1'b1;  // State B: next y[1] always 1
            3'b010: next_y1 = w;     // State C: next y[1] equals w
            3'b011: next_y1 = 1'b0;  // State D: next y[1] always 0
            3'b100: next_y1 = w;     // State E: next y[1] equals w
            3'b101: next_y1 = 1'b1;  // State F: next y[1] always 1
            default: next_y1 = 1'b0;
        endcase
    end

endmodule