module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out // Declare out as a reg
);

// Directly implement the Karnaugh map using a case statement
always @(a, b, c, d) begin
    case ({a, b, c, d}) // Ensure correct ordering of bits in the case statement
        4'b0000, 4'b0001, 4'b0010, 4'b0100, 4'b0101, 4'b0111, 4'b1000, 4'b1001, 4'b1010, 4'b1101, 4'b1110: out = 1;
        default: out = 0;
    endcase
end

endmodule