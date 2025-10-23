module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    reg [5:0] next_state;

    // Next state logic
    always @(*) begin
        case (1'b1)
            y[0]: next_state = w ? 6'b000010 : 6'b000001;  // A -> B or A
            y[1]: next_state = w ? 6'b000100 : 6'b001000;  // B -> C or D
            y[2]: next_state = w ? 6'b010000 : 6'b001000;  // C -> E or D
            y[3]: next_state = w ? 6'b100000 : 6'b000001;  // D -> F or A
            y[4]: next_state = w ? 6'b010000 : 6'b001000;  // E -> E or D
            y[5]: next_state = w ? 6'b000100 : 6'b001000;  // F -> C or D
            default: next_state = 6'b000001;               // Default to A
        endcase
    end

    // Output logic - next state values for the respective flip-flops
    assign Y1 = next_state[1];
    assign Y3 = next_state[3];

endmodule