module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    // Directly output y[1]
    assign Y1 = y[1];

    // Next-state logic for y[1]
    wire next_y1;
    always @(y, w) begin
        case (y)
            3'b000: next_y1 = (w == 1)? 0 : 0; // A to A or B
            3'b001: next_y1 = (w == 1)? 0 : 0; // B to B or C
            3'b010: next_y1 = (w == 1)? 1 : 1; // C to C or D
            3'b011: next_y1 = 1; // D to A or D
            3'b100: next_y1 = 1; // E to E or D
            3'b101: next_y1 = (w == 1)? 1 : 0; // F to C or D
            default: next_y1 = 0;
        endcase
    end

endmodule