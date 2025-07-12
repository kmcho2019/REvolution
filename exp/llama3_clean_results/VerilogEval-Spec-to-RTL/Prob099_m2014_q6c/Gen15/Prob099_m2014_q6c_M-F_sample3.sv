module TopModule(
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y2,
    output reg Y3,
    output reg Y4
);

always @(*) begin
    case ({y, w})
        // State A, w = 0
        7'b0000010: begin Y1 = 0; Y2 = 1; Y3 = 0; Y4 = 0; end
        // State A, w = 1
        7'b0000011: begin Y1 = 0; Y2 = 0; Y3 = 0; Y4 = 0; end
        // State B, w = 0
        7'b0000100: begin Y1 = 0; Y2 = 0; Y3 = 1; Y4 = 0; end
        // State B, w = 1
        7'b0000101: begin Y1 = 0; Y2 = 0; Y3 = 0; Y4 = 1; end
        // State C, w = 0
        7'b0001000: begin Y1 = 0; Y2 = 0; Y3 = 0; Y4 = 0; end
        // State C, w = 1
        7'b0001001: begin Y1 = 0; Y2 = 0; Y3 = 0; Y4 = 1; end
        // State D, w = 0
        7'b0010000: begin Y1 = 0; Y2 = 1; Y3 = 0; Y4 = 0; end
        // State D, w = 1
        7'b0010001: begin Y1 = 0; Y2 = 0; Y3 = 0; Y4 = 0; end
        // State E, w = 0
        7'b0100000: begin Y1 = 0; Y2 = 0; Y3 = 0; Y4 = 0; end
        // State E, w = 1
        7'b0100001: begin Y1 = 0; Y2 = 0; Y3 = 0; Y4 = 1; end
        // State F, w = 0
        7'b1000000: begin Y1 = 0; Y2 = 0; Y3 = 1; Y4 = 0; end
        // State F, w = 1
        7'b1000001: begin Y1 = 0; Y2 = 0; Y3 = 0; Y4 = 1; end
        default: begin Y1 = 0; Y2 = 0; Y3 = 0; Y4 = 0; end
    endcase
end

endmodule