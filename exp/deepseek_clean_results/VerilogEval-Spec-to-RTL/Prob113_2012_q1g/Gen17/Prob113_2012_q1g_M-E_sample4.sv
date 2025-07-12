module TopModule(
    input [3:0] x,
    output reg f
);
    always @(*) begin
        case (x)
            4'b0000: f = 1'b1;  // 00-00
            4'b0010: f = 1'b1;  // 00-10
            4'b1100: f = 1'b1;  // 11-00
            4'b1101: f = 1'b1;  // 11-01
            4'b1111: f = 1'b1;  // 11-11
            4'b1000: f = 1'b1;  // 10-00
            4'b1001: f = 1'b1;  // 10-01
            4'b1010: f = 1'b1;  // 10-10
            default: f = 1'b0;  // All other cases
        endcase
    end
endmodule