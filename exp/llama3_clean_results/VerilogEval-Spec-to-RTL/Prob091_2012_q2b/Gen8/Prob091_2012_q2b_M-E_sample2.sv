module TopModule(
    input  [5:0] y,
    input  w,
    output reg Y1,
    output reg Y3
);

    always @(*) begin
        case ({y, w})
            6'b0000010: {Y1, Y3} = 2'b10; // A, w=1 -> B
            6'b0000011: {Y1, Y3} = 2'b00; // A, w=0 -> A
            6'b0000100: {Y1, Y3} = 2'b00; // B, w=0 -> D
            6'b0000101: {Y1, Y3} = 2'b01; // B, w=1 -> C
            6'b0001000: {Y1, Y3} = 2'b00; // C, w=0 -> D
            6'b0001001: {Y1, Y3} = 2'b10; // C, w=1 -> E
            6'b0010000: {Y1, Y3} = 2'b00; // D, w=0 -> A
            6'b0010001: {Y1, Y3} = 2'b01; // D, w=1 -> F
            6'b0100000: {Y1, Y3} = 2'b00; // E, w=0 -> D
            6'b0100001: {Y1, Y3} = 2'b10; // E, w=1 -> E
            6'b1000000: {Y1, Y3} = 2'b00; // F, w=0 -> D
            6'b1000001: {Y1, Y3} = 2'b01; // F, w=1 -> C
            default: {Y1, Y3} = 2'b00;
        endcase
    end

endmodule