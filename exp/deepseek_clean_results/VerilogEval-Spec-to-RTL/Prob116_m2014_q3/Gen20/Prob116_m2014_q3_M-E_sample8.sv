module TopModule(
    input [3:0] x,  // x[3]x[2]x[1]x[0] corresponds to x[4]x[3]x[2]x[1] in K-map
    output reg f
);
    always @(*) begin
        case (x)
            4'b0000: f = 1'b0;  // d -> choose 0 to simplify
            4'b0001: f = 1'b0;
            4'b0010: f = 1'b0;  // d -> choose 0 to simplify
            4'b0011: f = 1'b0;  // d -> choose 0 to simplify
            4'b0100: f = 1'b0;
            4'b0101: f = 1'b0;  // d -> choose 0 to match adjacent 0
            4'b0110: f = 1'b1;
            4'b0111: f = 1'b0;
            4'b1000: f = 1'b1;
            4'b1001: f = 1'b1;
            4'b1010: f = 1'b1;
            4'b1011: f = 1'b1;  // d -> choose 1 to match adjacent 1s
            4'b1100: f = 1'b1;
            4'b1101: f = 1'b1;
            4'b1110: f = 1'b0;  // d -> choose 0 to simplify
            4'b1111: f = 1'b1;  // d -> choose 1 to simplify
        endcase
    end
endmodule