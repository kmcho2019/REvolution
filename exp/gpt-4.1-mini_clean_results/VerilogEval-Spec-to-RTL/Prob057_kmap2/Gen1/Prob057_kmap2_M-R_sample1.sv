module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Function to convert (x,y) from binary to Gray code index as per K-map order 00,01,11,10
    function [1:0] bin_to_gray;
        input x, y;
        begin
            // Map input bits to K-map Gray code order:
            // Binary 00 -> Gray 00 (0)
            // Binary 01 -> Gray 01 (1)
            // Binary 10 -> Gray 11 (3)
            // Binary 11 -> Gray 10 (2)
            case ({x,y})
                2'b00: bin_to_gray = 2'b00;
                2'b01: bin_to_gray = 2'b01;
                2'b11: bin_to_gray = 2'b10;
                2'b10: bin_to_gray = 2'b11;
                default: bin_to_gray = 2'b00; // default safe
            endcase
        end
    endfunction

    // Convert inputs to K-map indices using Gray code mapping
    wire [1:0] row = bin_to_gray(c,d); // cd mapping
    wire [1:0] col = bin_to_gray(a,b); // ab mapping

    // Combine to form 4-bit index: high 2 bits = row, low 2 bits = col
    wire [3:0] index = {row, col};

    // Assign output using a combinational case expression directly
    assign out = (index == 4'b0000) ? 1 : // cd=00 ab=00
                 (index == 4'b0001) ? 1 : // cd=00 ab=01
                 (index == 4'b0010) ? 0 : // cd=00 ab=11
                 (index == 4'b0011) ? 1 : // cd=00 ab=10
                 (index == 4'b0100) ? 1 : // cd=01 ab=00
                 (index == 4'b0101) ? 0 : // cd=01 ab=01
                 (index == 4'b0110) ? 0 : // cd=01 ab=11
                 (index == 4'b0111) ? 1 : // cd=01 ab=10
                 (index == 4'b1000) ? 0 : // cd=11 ab=00
                 (index == 4'b1001) ? 1 : // cd=11 ab=01
                 (index == 4'b1010) ? 1 : // cd=11 ab=11
                 (index == 4'b1011) ? 1 : // cd=11 ab=10
                 (index == 4'b1100) ? 1 : // cd=10 ab=00
                 (index == 4'b1101) ? 1 : // cd=10 ab=01
                 (index == 4'b1110) ? 0 : // cd=10 ab=11
                 (index == 4'b1111) ? 0 : // cd=10 ab=10
                 0; // default

endmodule