module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

    // LUT-based implementation using a case statement
    always @(y, w) begin
        case ({y, w})
            6'b000001_0: {Y1, Y3} = 2'b00; // A(0) -> A
            6'b000001_1: {Y1, Y3} = 2'b10; // A(1) -> B
            6'b000010_0: {Y1, Y3} = 2'b00; // B(0) -> D
            6'b000010_1: {Y1, Y3} = 2'b00; // B(1) -> C
            6'b000100_0: {Y1, Y3} = 2'b00; // C(0) -> D
            6'b000100_1: {Y1, Y3} = 2'b10; // C(1) -> E
            6'b001000_0: {Y1, Y3} = 2'b00; // D(0) -> A
            6'b001000_1: {Y1, Y3} = 2'b10; // D(1) -> F
            6'b010000_0: {Y1, Y3} = 2'b00; // E(0) -> D
            6'b010000_1: {Y1, Y3} = 2'b10; // E(1) -> E
            6'b100000_0: {Y1, Y3} = 2'b00; // F(0) -> D
            6'b100000_1: {Y1, Y3} = 2'b00; // F(1) -> C
            default: {Y1, Y3} = 2'b00; // default case
        endcase
    end

endmodule