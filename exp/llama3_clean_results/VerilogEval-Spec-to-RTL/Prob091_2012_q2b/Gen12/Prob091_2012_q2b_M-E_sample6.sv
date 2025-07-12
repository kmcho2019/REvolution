module TopModule #(
    parameter WIDTH = 6
) (
    input  [WIDTH-1:0] y,
    input  w,
    output reg Y1,
    output reg Y3
);

    reg [WIDTH-1:0] next_state;

    always @(*) begin
        case ({y, w})
            6'b0000010: next_state = 6'b000010; // A (0) --1--> B
            6'b0000011: next_state = 6'b000001; // A (0) --0--> A
            6'b0000100: next_state = 6'b000100; // B (0) --1--> C
            6'b0000101: next_state = 6'b001000; // B (0) --0--> D
            6'b0001000: next_state = 6'b010000; // C (0) --1--> E
            6'b0001001: next_state = 6'b001000; // C (0) --0--> D
            6'b0010000: next_state = 6'b100000; // D (0) --1--> F
            6'b0010001: next_state = 6'b000001; // D (0) --0--> A
            6'b0100000: next_state = 6'b010000; // E (1) --1--> E
            6'b0100001: next_state = 6'b001000; // E (1) --0--> D
            6'b1000000: next_state = 6'b000100; // F (1) --1--> C
            6'b1000001: next_state = 6'b001000; // F (1) --0--> D
            default: next_state = 6'b000001; // Default state
        endcase

        Y1 = next_state[1];
        Y3 = next_state[3];
    end

endmodule