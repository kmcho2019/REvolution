module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

    // Function to map binary pair (x,y) into K-map Gray code order (00,01,11,10)
    function [1:0] to_gray_index;
        input x, y;
        begin
            case ({x,y})
                2'b00: to_gray_index = 2'b00;
                2'b01: to_gray_index = 2'b01;
                2'b11: to_gray_index = 2'b11;
                2'b10: to_gray_index = 2'b10;
                default: to_gray_index = 2'b00;
            endcase
        end
    endfunction

    // Map inputs to K-map row and column indices
    wire [1:0] row = to_gray_index(c, d); // cd pair
    wire [1:0] col = to_gray_index(a, b); // ab pair

    wire [3:0] index = {row, col}; // Concatenate for 4-bit minterm index

    always @(*) begin
        case (index)
            4'b0000, // cd=00 ab=00 -> 1
            4'b0001, // cd=00 ab=01 -> 1
            4'b0011, // cd=00 ab=10 -> 1
            4'b0100, // cd=01 ab=00 -> 1
            4'b0111, // cd=01 ab=10 -> 1
            4'b1001, // cd=11 ab=01 -> 1
            4'b1010, // cd=11 ab=11 -> 1
            4'b1011, // cd=11 ab=10 -> 1
            4'b1100, // cd=10 ab=00 -> 1
            4'b1101: // cd=10 ab=01 -> 1
                out = 1'b1;
            default:
                out = 1'b0;
        endcase
    end

endmodule