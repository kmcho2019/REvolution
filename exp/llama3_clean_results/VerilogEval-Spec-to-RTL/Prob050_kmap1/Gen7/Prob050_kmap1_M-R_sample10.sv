module TopModule(
    input a,
    input b,
    input c,
    output reg out
);

always @(*) begin
    // Implement the simplified expression based on the Karnaugh map's logic
    out = a | b | c;
end

endmodule