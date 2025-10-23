module TopModule(
    input  [5:0] y,
    input  w,
    output reg Y1,
    output reg Y3
);

    always @(*) begin
        case ({y, w})
            // State A (000001) transitions
            6'b000001_0: {Y1, Y3} = 2'b00; // A (0) -> A
            6'b000001_1: {Y1, Y3} = 2'b10; // A (1) -> B

            // State B (000010) transitions
            6'b000010_0: {Y1, Y3} = 2'b00; // B (0) -> D
            6'b000010_1: {Y1, Y3} = 2'b00; // B (1) -> C

            // State C (000100) transitions
            6'b000100_0: {Y1, Y3} = 2'b00; // C (0) -> D
            6'b000100_1: {Y1, Y3} = 2'b00; // C (1) -> E

            // State D (001000) transitions
            6'b001000_0: {Y1, Y3} = 2'b00; // D (0) -> A
            6'b001000_1: {Y1, Y3} = 2'b00; // D (1) -> F

            // State E (010000) transitions
            6'b010000_0: {Y1, Y3} = 2'b00; // E (0) -> D
            6'b010000_1: {Y1, Y3} = 2'b00; // E (1) -> E

            // State F (100000) transitions
            6'b100000_0: {Y1, Y3} = 2'b00; // F (0) -> D
            6'b100000_1: {Y1, Y3} = 2'b00; // F (1) -> C

            default: {Y1, Y3} = 2'b00; // Default case
        endcase
    end

endmodule