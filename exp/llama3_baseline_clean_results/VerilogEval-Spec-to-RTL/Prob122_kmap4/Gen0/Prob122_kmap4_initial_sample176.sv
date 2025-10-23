module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Implementing the Karnaugh map directly
always @(a, b, c, d) begin
    case ({c, d})
        2'b00: out = (a == 1'b0 && b == 1'b1) || (a == 1'b1 && b == 1'b0);
        2'b01: out = (a == 1'b0 && b == 1'b0) || (a == 1'b1 && b == 1'b1);
        2'b11: out = (a == 1'b0 && b == 1'b1) || (a == 1'b1 && b == 1'b0);
        2'b10: out = (a == 1'b0 && b == 1'b0) || (a == 1'b1 && b == 1'b1);
    endcase
end

endmodule