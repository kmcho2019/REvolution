module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Map inputs to variables for clarity
    // According to K-map:
    // Rows: cd (c is MSB, d is LSB)
    // Columns: ab (a is MSB, b is LSB)
    // So index = {c,d,a,b}

    wire [3:0] index = {c,d,a,b};

    reg out_reg;

    always @(*) begin
        case(index)
            4'b0000: out_reg = 1; // cd=00, ab=00
            4'b0001: out_reg = 1; // cd=00, ab=01
            4'b0011: out_reg = 0; // cd=00, ab=11
            4'b0010: out_reg = 1; // cd=00, ab=10

            4'b0100: out_reg = 1; // cd=01, ab=00
            4'b0101: out_reg = 0; // cd=01, ab=01
            4'b0111: out_reg = 0; // cd=01, ab=11
            4'b0110: out_reg = 1; // cd=01, ab=10

            4'b1100: out_reg = 0; // cd=11, ab=00
            4'b1101: out_reg = 1; // cd=11, ab=01
            4'b1111: out_reg = 1; // cd=11, ab=11
            4'b1110: out_reg = 1; // cd=11, ab=10

            4'b1000: out_reg = 1; // cd=10, ab=00
            4'b1001: out_reg = 1; // cd=10, ab=01
            4'b1011: out_reg = 0; // cd=10, ab=11
            4'b1010: out_reg = 0; // cd=10, ab=10

            default: out_reg = 0;
        endcase
    end

    assign out = out_reg;

endmodule