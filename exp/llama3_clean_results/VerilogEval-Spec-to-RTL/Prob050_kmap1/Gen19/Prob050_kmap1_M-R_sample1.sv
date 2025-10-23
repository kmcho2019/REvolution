module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Implementing the logic from the Karnaugh map using an always block
always @(*) begin
    // 'out' is 1 if 'a' is 1 or if either 'b' or 'c' is 1
    out = a | b | c;
end

endmodule