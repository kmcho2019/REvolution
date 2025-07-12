module TopModule(
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y3
);

always @(*) begin
    case ({y, w})
        // State A, w = 0
        6'b000001_0: begin Y1 = 0; Y3 = 0; end
        // State A, w = 1
        6'b000001_1: begin Y1 = 1; Y3 = 0; end
        // State B, w = 0
        6'b000010_0: begin Y1 = 0; Y3 = 0; end
        // State B, w = 1
        6'b000010_1: begin Y1 = 0; Y3 = 1; end
        // State C, w = 0
        6'b000100_0: begin Y1 = 0; Y3 = 0; end
        // State C, w = 1
        6'b000100_1: begin Y1 = 0; Y3 = 0; end
        // State D, w = 0
        6'b001000_0: begin Y1 = 1; Y3 = 0; end
        // State D, w = 1
        6'b001000_1: begin Y1 = 0; Y3 = 0; end
        // State E, w = 0
        6'b010000_0: begin Y1 = 0; Y3 = 0; end
        // State E, w = 1
        6'b010000_1: begin Y1 = 0; Y3 = 1; end
        // State F, w = 0
        6'b100000_0: begin Y1 = 0; Y3 = 0; end
        // State F, w = 1
        6'b100000_1: begin Y1 = 0; Y3 = 0; end
        default: begin Y1 = 0; Y3 = 0; end
    endcase
end

endmodule