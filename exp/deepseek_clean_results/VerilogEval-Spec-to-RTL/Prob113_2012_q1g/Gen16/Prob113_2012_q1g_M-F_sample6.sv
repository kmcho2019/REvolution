module TopModule(
    input [3:0] x,
    output reg f
);
    always @(*) begin
        case (x)
            4'b0000: f = 1;  // Row 00, Col 00
            4'b0010: f = 1;  // Row 00, Col 10
            4'b1100: f = 1;  // Row 11, Col 00
            4'b1101: f = 1;  // Row 11, Col 01
            4'b1111: f = 1;  // Row 11, Col 11
            4'b1000: f = 1;  // Row 10, Col 00
            4'b1001: f = 1;  // Row 10, Col 01
            4'b1010: f = 1;  // Row 10, Col 10 (missing case)
            default: f = 0;  // All other cases
        endcase
    end
endmodule