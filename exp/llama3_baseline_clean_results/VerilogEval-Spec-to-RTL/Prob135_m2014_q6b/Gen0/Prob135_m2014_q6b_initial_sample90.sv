module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

// Next-state logic for y[1]
assign Y1 = y[1];

// Next-state logic for y[1]
always @(y, w) begin
    case(y)
        3'b000: Y1 = w;  // A
        3'b001: Y1 = w;  // B
        3'b010: Y1 = w ? 1 : 1;  // C
        3'b011: Y1 = w ? 1 : 1;  // D
        3'b100: Y1 = w ? 1 : 1;  // E
        3'b101: Y1 = w ? 1 : 0;  // F
        default: Y1 = 0;
    endcase
end

// But the above code is for the next state, it is not the current state
// To get the current state output, we should directly use y[1]
assign Y1 = y[1];

endmodule