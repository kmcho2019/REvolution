module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Function to convert binary 2-bit to K-map Gray code ordering index
    // binary 00 -> 0 (00)
    // binary 01 -> 1 (01)
    // binary 10 -> 3 (11)
    // binary 11 -> 2 (10)
    function [1:0] bin2gray;
        input [1:0] bin;
        begin
            case (bin)
                2'b00: bin2gray = 2'b00;
                2'b01: bin2gray = 2'b01;
                2'b10: bin2gray = 2'b11;
                2'b11: bin2gray = 2'b10;
                default: bin2gray = 2'b00;
            endcase
        end
    endfunction

    wire [1:0] row_gray = bin2gray({c,d});
    wire [1:0] col_gray = bin2gray({a,b});
    wire [3:0] index = {row_gray, col_gray};

    reg out_reg;

    always @(*) begin
        case(index)
            4'b0000: out_reg = 1; // cd=00 ab=00
            4'b0001: out_reg = 1; // cd=00 ab=01
            4'b0011: out_reg = 0; // cd=00 ab=11
            4'b0010: out_reg = 1; // cd=00 ab=10
            4'b0100: out_reg = 1; // cd=01 ab=00
            4'b0101: out_reg = 0; // cd=01 ab=01
            4'b0111: out_reg = 0; // cd=01 ab=11
            4'b0110: out_reg = 1; // cd=01 ab=10
            4'b1100: out_reg = 0; // cd=11 ab=00
            4'b1101: out_reg = 1; // cd=11 ab=01
            4'b1111: out_reg = 1; // cd=11 ab=11
            4'b1110: out_reg = 1; // cd=11 ab=10
            4'b1000: out_reg = 1; // cd=10 ab=00
            4'b1001: out_reg = 1; // cd=10 ab=01
            4'b1011: out_reg = 0; // cd=10 ab=11
            4'b1010: out_reg = 0; // cd=10 ab=10
            default: out_reg = 0;
        endcase
    end

    assign out = out_reg;

endmodule