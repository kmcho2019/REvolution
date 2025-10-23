module TopModule(
    input [3:0] x,
    output reg f
);
    always @(*) begin
        case (x)
            4'b0000: f = 1;  // x3x2=00, x1x0=00 (top-left)
            4'b0010: f = 1;  // x3x2=00, x1x0=10 (top-right)
            4'b1100: f = 1;  // x3x2=11, x1x0=00 (middle-left)
            4'b1111: f = 1;  // x3x2=11, x1x0=11 (middle-right)
            4'b1000: f = 1;  // x3x2=10, x1x0=00 (bottom-left)
            4'b1001: f = 1;  // x3x2=10, x1x0=01 (bottom-middle)
            4'b1010: f = 1;  // x3x2=10, x1x0=10 (bottom-right)
            4'b1011: f = 1;  // x3x2=10, x1x0=11 (bottom-right)
            default: f = 0;  // All other cases
        endcase
    end
endmodule