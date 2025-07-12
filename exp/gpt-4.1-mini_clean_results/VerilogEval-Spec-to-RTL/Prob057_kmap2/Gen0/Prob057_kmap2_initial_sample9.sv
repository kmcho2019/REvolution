module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Map inputs to indices:
    // ab: 00=0, 01=1, 11=2, 10=3
    // cd: 00=0, 01=1, 11=2, 10=3
    // We'll use a,b for columns and c,d for rows.
    // Calculate row and column indices:
    wire [1:0] row = {c,d};
    wire [1:0] col = {a,b};
    wire [3:0] index = {row, col};

    reg out_reg;

    always @(*) begin
        case(index)
            4'b0000: out_reg = 1; // cd=00 ab=00
            4'b0001: out_reg = 1; // cd=00 ab=01
            4'b0010: out_reg = 0; // cd=00 ab=11
            4'b0011: out_reg = 1; // cd=00 ab=10
            4'b0100: out_reg = 1; // cd=01 ab=00
            4'b0101: out_reg = 0; // cd=01 ab=01
            4'b0110: out_reg = 0; // cd=01 ab=11
            4'b0111: out_reg = 1; // cd=01 ab=10
            4'b1000: out_reg = 0; // cd=11 ab=00
            4'b1001: out_reg = 1; // cd=11 ab=01
            4'b1010: out_reg = 1; // cd=11 ab=11
            4'b1011: out_reg = 1; // cd=11 ab=10
            4'b1100: out_reg = 1; // cd=10 ab=00
            4'b1101: out_reg = 1; // cd=10 ab=01
            4'b1110: out_reg = 0; // cd=10 ab=11
            4'b1111: out_reg = 0; // cd=10 ab=10
            default: out_reg = 0;
        endcase
    end

    assign out = out_reg;

endmodule