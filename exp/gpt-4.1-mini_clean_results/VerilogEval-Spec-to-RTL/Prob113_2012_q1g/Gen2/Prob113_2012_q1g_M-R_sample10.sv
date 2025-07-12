module TopModule(
    input  [3:0] x,
    output reg f
);

    // According to problem mapping:
    // Rows = x[2]x[3], Columns = x[0]x[1]
    // To interpret input as per Karnaugh map:
    // row = {x[2], x[3]} (2 bits)
    // col = {x[0], x[1]} (2 bits)
    // For each combination of row and col, set output f according to K-map.

    always @(*) begin
        case ({x[2], x[3], x[0], x[1]})
            // row=00 (x[2]=0,x[3]=0)
            4'b0000: f = 1; // col=00
            4'b0001: f = 0; // col=01
            4'b0011: f = 0; // col=11
            4'b0010: f = 1; // col=10

            // row=01 (x[2]=0,x[3]=1)
            4'b0100: f = 0;
            4'b0101: f = 0;
            4'b0111: f = 0;
            4'b0110: f = 0;

            // row=11 (x[2]=1,x[3]=1)
            4'b1100: f = 1;
            4'b1101: f = 1;
            4'b1111: f = 1;
            4'b1110: f = 0;

            // row=10 (x[2]=1,x[3]=0)
            4'b1000: f = 1;
            4'b1001: f = 1;
            4'b1011: f = 0;
            4'b1010: f = 1;

            default: f = 0; // Just in case
        endcase
    end

endmodule