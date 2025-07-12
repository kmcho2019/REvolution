module TopModule(
    input [3:0] x,
    output reg f
);
    always @(*) begin
        case (x)
            4'b0000: f = 1;  // Row 00, Col 00
            4'b0010: f = 1;  // Row 00, Col 10
            4'b1100: f = 1;  // Row 11, Col 00
            4'b1010: f = 1;  // Row 10, Col 10
            default: f = 0;  // All other cases
        endcase
    end
endmodule