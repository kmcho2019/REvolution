module TopModule(
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    reg next_y1;

    always @(*) begin
        case (y)
            3'b000: next_y1 = 1'b0;          // A: next y[1] = 0
            3'b001: next_y1 = 1'b1;          // B: next y[1] = 1
            3'b010: next_y1 = w;             // C: next y[1] = w
            3'b011: next_y1 = 1'b0;          // D: next y[1] = 0
            3'b100: next_y1 = w;             // E: next y[1] = w
            3'b101: next_y1 = 1'b1;          // F: next y[1] = 1
            default: next_y1 = 1'b0;         // Default fallback
        endcase
    end

    // Output Y1 is current y[1]
    assign Y1 = y[1];

endmodule