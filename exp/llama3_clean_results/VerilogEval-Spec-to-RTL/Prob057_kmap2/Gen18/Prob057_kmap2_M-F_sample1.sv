module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out // Declare 'out' as a reg type
);

// Use a case statement to implement the lookup table based on the Karnaugh map
always @(*) begin
    case ({a, b, c, d}) // Corrected the order to match the Karnaugh map
        4'b0000: out = 1'b1;
        4'b0001: out = 1'b1;
        4'b0010: out = 1'b0;
        4'b0011: out = 1'b1;
        4'b0100: out = 1'b1;
        4'b0101: out = 1'b0;
        4'b0110: out = 0;
        4'b0111: out = 1'b1;
        4'b1000: out = 1'b0;
        4'b1001: out = 1'b1;
        4'b1010: out = 1'b1;
        4'b1011: out = 1'b1;
        4'b1100: out = 1'b1;
        4'b1101: out = 1'b1;
        4'b1110: out = 1'b0;
        4'b1111: out = 1'b0;
        default: out = 1'b0; // Default case, should not occur
    endcase
end

endmodule