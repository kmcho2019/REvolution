module TopModule(
    input [3:0] x,  // x[3:4] = rows, x[1:2] = columns
    output reg f
);
    always @(*) begin
        case ({x[3], x[0], x[1], x[2]})  // {row, column} bits
            // x[3]x[0]=00 (rows)
            4'b00_00: f = 1'b0;  // d -> choose 0
            4'b00_01: f = 1'b0;  // specified 0
            4'b00_11: f = 1'b0;  // d -> choose 0
            4'b00_10: f = 1'b0;  // d -> choose 0

            // x[3]x[0]=01 (rows)
            4'b01_00: f = 1'b0;  // specified 0
            4'b01_01: f = 1'b0;  // d -> choose 0
            4'b01_11: f = 1'b1;  // specified 1
            4'b01_10: f = 1'b0;  // specified 0

            // x[3]x[0]=11 (rows)
            4'b11_00: f = 1'b1;  // specified 1
            4'b11_01: f = 1'b1;  // specified 1
            4'b11_11: f = 1'b0;  // d -> choose 0
            4'b11_10: f = 1'b0;  // d -> choose 0

            // x[3]x[0]=10 (rows)
            4'b10_00: f = 1'b1;  // specified 1
            4'b10_01: f = 1'b1;  // specified 1
            4'b10_11: f = 1'b0;  // specified 0
            4'b10_10: f = 1'b0;  // d -> choose 0

            default: f = 1'b0;
        endcase
    end
endmodule