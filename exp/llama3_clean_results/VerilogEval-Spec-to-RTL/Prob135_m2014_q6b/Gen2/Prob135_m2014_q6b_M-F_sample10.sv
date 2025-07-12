module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    reg Y1_next;

    always @(y or w) begin
        case(y)
            3'b000: Y1_next = w; // A to A or A to B
            3'b001: Y1_next = 1'b1; // B to C or B to D, y[1] remains 1
            3'b010: Y1_next = 1'b1; // C to E or C to D, y[1] remains 1
            3'b011: Y1_next = w || ~w; // D to A or D to F, y[1] remains 1 if w is 1 or 0
            3'b100: Y1_next = 1'b0; // state E is actually 3'b101, this is an error, set to 0
            3'b101: Y1_next = w; // E to E or E to D, y[1] remains 1 if w is 1
            3'b110: Y1_next = 1'b0; // unused state, default to 0
            3'b111: Y1_next = w; // F to C or F to D, y[1] remains 1 if w is 1
        endcase
    end

    assign Y1 = Y1_next;

endmodule