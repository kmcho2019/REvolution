module TopModule(
    input  [5:0] y,
    input  w,
    output reg Y1,
    output reg Y3
);

    always @(*) begin
        case ({y, w})
            6'b000001_0: begin Y1 = 0; Y3 = 0; end // A (0) --0--> A
            6'b000001_1: begin Y1 = 1; Y3 = 0; end // A (0) --1--> B
            6'b000010_0: begin Y1 = 0; Y3 = 1; end // B (0) --0--> D
            6'b000010_1: begin Y1 = 0; Y3 = 1; end // B (0) --1--> C
            6'b000100_0: begin Y1 = 0; Y3 = 1; end // C (0) --0--> D
            6'b000100_1: begin Y1 = 0; Y3 = 0; end // C (0) --1--> E
            6'b001000_0: begin Y1 = 0; Y3 = 0; end // D (0) --0--> A
            6'b001000_1: begin Y1 = 0; Y3 = 1; end // D (0) --1--> F
            6'b010000_0: begin Y1 = 0; Y3 = 1; end // E (1) --0--> D
            6'b010000_1: begin Y1 = 0; Y3 = 0; end // E (1) --1--> E
            6'b100000_0: begin Y1 = 0; Y3 = 1; end // F (1) --0--> D
            6'b100000_1: begin Y1 = 0; Y3 = 0; end // F (1) --1--> C
            default: begin Y1 = 0; Y3 = 0; end
        endcase
    end

endmodule