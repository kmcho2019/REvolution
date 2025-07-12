module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

always @(*) begin
    out_and = &in;  // 4-input AND gate
    out_or  = |in;  // 4-input OR gate
    out_xor = ^in;  // 4-input XOR gate
end

endmodule