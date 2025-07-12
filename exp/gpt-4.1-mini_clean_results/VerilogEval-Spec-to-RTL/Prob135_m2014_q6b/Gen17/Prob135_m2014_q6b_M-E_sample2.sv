module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    reg next_y1;

    always @(*) begin
        case (y)
            3'b000: next_y1 = 1'b0;                   // A: y=000
            3'b001: next_y1 = 1'b0;                   // B: y=001
            3'b010: next_y1 = 1'b1;                   // C: y=010
            3'b011: next_y1 = 1'b0;                   // D: y=011
            3'b100: next_y1 = 1'b1;                   // E: y=100
            3'b101: next_y1 = 1'b0;                   // F: y=101
            default: next_y1 = 1'b0;                   // Default safe state
        endcase
    end

    assign Y1 = y[1];

endmodule