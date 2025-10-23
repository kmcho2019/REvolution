module TopModule(
    input [3:0] x,
    output reg f
);
    always @(*) begin
        case (x)
            4'b0000: f = 1'b1;  // 0000
            4'b0010: f = 1'b1;  // 0010
            4'b1100: f = 1'b1;  // 1100
            4'b1101: f = 1'b1;  // 1101
            4'b1111: f = 1'b1;  // 1111
            4'b1000: f = 1'b1;  // 1000
            4'b1001: f = 1'b1;  // 1001
            4'b1010: f = 1'b1;  // 1010
            default: f = 1'b0;  // All other cases
        endcase
    end
endmodule