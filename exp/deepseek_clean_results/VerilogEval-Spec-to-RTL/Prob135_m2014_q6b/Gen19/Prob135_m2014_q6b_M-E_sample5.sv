module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    reg next_y1;
    assign Y1 = y[1];

    always @(*) begin
        case (y)
            3'b000: next_y1 = 1'b0; // State A: next y[1] is 0 (to B or A)
            3'b001: next_y1 = w;    // State B: next y[1] is w (to C=0 or D=1)
            3'b010: next_y1 = w;    // State C: next y[1] is w (to E=0 or D=1)
            3'b011: next_y1 = ~w;   // State D: next y[1] is ~w (to F=1 or A=0)
            3'b100: next_y1 = w;    // State E: next y[1] is w (to E=0 or D=1)
            3'b101: next_y1 = ~w;   // State F: next y[1] is ~w (to C=0 or D=1)
            default: next_y1 = 1'b0;
        endcase
    end

endmodule