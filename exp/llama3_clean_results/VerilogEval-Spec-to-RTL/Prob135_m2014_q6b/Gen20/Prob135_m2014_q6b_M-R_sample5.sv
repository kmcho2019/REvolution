module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    reg [2:0] next_state;

    always @(*) begin
        case (y)
            3'b000: next_state = w ? 3'b000 : 3'b001; // A
            3'b001: next_state = w ? 3'b011 : 3'b010; // B
            3'b010: next_state = w ? 3'b011 : 3'b100; // C
            3'b011: next_state = w ? 3'b000 : 3'b101; // D
            3'b100: next_state = w ? 3'b011 : 3'b100; // E
            3'b101: next_state = w ? 3'b011 : 3'b010; // F
            default: next_state = 3'b000; // default state
        endcase
    end

    assign Y1 = next_state[1];

endmodule