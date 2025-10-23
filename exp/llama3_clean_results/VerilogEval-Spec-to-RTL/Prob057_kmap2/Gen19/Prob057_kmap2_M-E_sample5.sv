module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Directly implement the Karnaugh map using a case statement
always @(a, b, c, d) begin
    case ({c, d, b, a})
        4'b0000, 4'b0001, 4'b0010, 4'b0100, 4'b0101, 4'b0111, 4'b1000, 4'b1001, 4'b1010, 4'b1101, 4'b1110, 4'b1111: out = 1;
        default: out = 0;
    endcase
end

endmodule