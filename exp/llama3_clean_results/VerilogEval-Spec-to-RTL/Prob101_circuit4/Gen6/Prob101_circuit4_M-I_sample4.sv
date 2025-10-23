module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Using an always block to define the combinational logic
always @(*) begin
    // The output q is 1 whenever b or c is 1, regardless of the values of a and d
    q = b | c;
end

endmodule