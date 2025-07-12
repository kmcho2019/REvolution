module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    // Define the next state lookup table
    reg [2:0] next_state;
    always @(y or w)
    begin
        case ({y, w})
            4'b0000: next_state = 3'b001; // A (0) --0--> B
            4'b0001: next_state = 3'b000; // A (0) --1--> A
            4'b0010: next_state = 3'b010; // B (0) --0--> C
            4'b0011: next_state = 3'b011; // B (0) --1--> D
            4'b0100: next_state = 3'b100; // C (0) --0--> E
            4'b0101: next_state = 3'b011; // C (0) --1--> D
            4'b0110: next_state = 3'b101; // D (0) --0--> F
            4'b0111: next_state = 3'b000; // D (0) --1--> A
            4'b1000: next_state = 3'b100; // E (1) --0--> E
            4'b1001: next_state = 3'b011; // E (1) --1--> D
            4'b1010: next_state = 3'b010; // F (1) --0--> C
            4'b1011: next_state = 3'b011; // F (1) --1--> D
            default: next_state = 3'b000;
        endcase
    end

    // Assign the next state value to the output
    assign Y1 = next_state[1];

endmodule