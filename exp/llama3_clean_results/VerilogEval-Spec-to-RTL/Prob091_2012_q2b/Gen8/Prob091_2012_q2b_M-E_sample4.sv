module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

    reg Y1_reg;
    reg Y3_reg;

    always @(*) begin
        case ({y, w})
            // A (000001) transitions
            6'b000001_0: begin Y1_reg = 1'b0; Y3_reg = 1'b0; end
            6'b000001_1: begin Y1_reg = 1'b1; Y3_reg = 1'b0; end

            // B (000010) transitions
            6'b000010_0: begin Y1_reg = 1'b0; Y3_reg = 1'b0; end
            6'b000010_1: begin Y1_reg = 1'b0; Y3_reg = 1'b1; end

            // C (000100) transitions
            6'b000100_0: begin Y1_reg = 1'b0; Y3_reg = 1'b0; end
            6'b000100_1: begin Y1_reg = 1'b0; Y3_reg = 1'b0; end

            // D (001000) transitions
            6'b001000_0: begin Y1_reg = 1'b0; Y3_reg = 1'b0; end
            6'b001000_1: begin Y1_reg = 1'b0; Y3_reg = 1'b0; end

            // E (010000) transitions
            6'b010000_0: begin Y1_reg = 1'b0; Y3_reg = 1'b1; end
            6'b010000_1: begin Y1_reg = 1'b0; Y3_reg = 1'b1; end

            // F (100000) transitions
            6'b100000_0: begin Y1_reg = 1'b0; Y3_reg = 1'b0; end
            6'b100000_1: begin Y1_reg = 1'b0; Y3_reg = 1'b1; end

            default: begin Y1_reg = 1'b0; Y3_reg = 1'b0; end
        endcase
    end

    assign Y1 = Y1_reg;
    assign Y3 = Y3_reg;

endmodule