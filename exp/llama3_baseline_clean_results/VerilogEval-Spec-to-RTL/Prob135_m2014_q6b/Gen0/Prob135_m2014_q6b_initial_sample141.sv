module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

// Current state to next state logic for y[1]
reg next_y1;
always @(*) begin
    case (y)
        3'b000: next_y1 = w; // A
        3'b001: next_y1 = w; // B
        3'b010: next_y1 = 1'b1; // C
        3'b011: next_y1 = ~w; // D
        3'b100: next_y1 = 1'b1; // E
        3'b101: next_y1 = ~w; // F
        default: next_y1 = 1'b0;
    endcase
end

// Output Y1 is y[1]
assign Y1 = y[1];

endmodule