module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    reg next_y1;

    always @(*) begin
        case (y)
            3'b000: next_y1 = 1'b0;               // A (000), transitions on w ignored for y[1]
            3'b001: next_y1 = w ? 1'b1 : 1'b0;   // B (001), y1 depends on w
            3'b010: next_y1 = w ? 1'b1 : 1'b0;   // C (010), y1 depends on w
            3'b011: next_y1 = w ? 1'b0 : 1'b1;   // D (011), y1 depends on w
            3'b100: next_y1 = 1'b1;               // E (100), always 1 for y[1]
            3'b101: next_y1 = w ? 1'b1 : 1'b0;   // F (101), y1 depends on w
            default: next_y1 = 1'b0;
        endcase
    end

    assign Y1 = y[1];  // Output the current state's y[1]

endmodule