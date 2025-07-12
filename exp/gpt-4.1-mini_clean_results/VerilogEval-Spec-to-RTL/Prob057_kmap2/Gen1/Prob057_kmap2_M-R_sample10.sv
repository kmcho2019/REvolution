module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

    // Combine inputs into a 4-bit vector [c d a b]
    wire [3:0] inputs = {c, d, a, b};

    always @(*) begin
        case (inputs)
            4'b0000, // minterm 0
            4'b0001, // minterm 1
            4'b0010, // minterm 2
            4'b0100, // minterm 4
            4'b0110, // minterm 6
            4'b1000, // minterm 8
            4'b1001, // minterm 9
            4'b1101, // minterm 13
            4'b1110, // minterm 14
            4'b1111: // minterm 15
                out = 1'b1;
            default:
                out = 1'b0;
        endcase
    end

endmodule