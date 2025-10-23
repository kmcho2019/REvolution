module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

    always @(*) begin
        case ({y, w})
            // State A (y[0]) to State B (y[1]) when w is 1
            6'b000001_1: begin Y1 = 1'b1; Y3 = 1'b0; end
            // State A (y[0]) to State A (y[0]) when w is 0
            6'b000001_0: begin Y1 = 1'b0; Y3 = 1'b0; end
            // State B (y[1]) to State C (y[2]) when w is 1
            6'b000010_1: begin Y1 = 1'b0; Y3 = 1'b0; end
            // State B (y[1]) to State D (y[3]) when w is 0
            6'b000010_0: begin Y1 = 1'b0; Y3 = 1'b1; end
            // State C (y[2]) to State E (y[4]) when w is 1
            6'b000100_1: begin Y1 = 1'b0; Y3 = 1'b0; end
            // State C (y[2]) to State D (y[3]) when w is 0
            6'b000100_0: begin Y1 = 1'b0; Y3 = 1'b1; end
            // State D (y[3]) to State F (y[5]) when w is 1
            6'b001000_1: begin Y1 = 1'b0; Y3 = 1'b0; end
            // State D (y[3]) to State A (y[0]) when w is 0
            6'b001000_0: begin Y1 = 1'b0; Y3 = 1'b0; end
            // State E (y[4]) to State E (y[4]) when w is 1
            6'b010000_1: begin Y1 = 1'b0; Y3 = 1'b0; end
            // State E (y[4]) to State D (y[3]) when w is 0
            6'b010000_0: begin Y1 = 1'b0; Y3 = 1'b1; end
            // State F (y[5]) to State C (y[2]) when w is 1
            6'b100000_1: begin Y1 = 1'b0; Y3 = 1'b0; end
            // State F (y[5]) to State D (y[3]) when w is 0
            6'b100000_0: begin Y1 = 1'b0; Y3 = 1'b1; end
            default: begin Y1 = 1'b0; Y3 = 1'b0; end
        endcase
    end

endmodule