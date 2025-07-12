module TopModule(
    input [3:0] x,
    output reg f
);
    always @(*) begin
        case (x)
            4'b0000: f = 1;  // Top-left corner
            4'b0010: f = 1;  // Top-right corner
            4'b1100: f = 1;  // Bottom-left quadrant
            4'b1101: f = 1;
            4'b1110: f = 1;
            4'b1111: f = 1;
            4'b1000: f = 1;  // Bottom-right quadrant
            4'b1001: f = 1;
            4'b1010: f = 1;
            default: f = 0;  // All other cases
        endcase
    end
endmodule