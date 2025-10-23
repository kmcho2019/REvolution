module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

// Use an always block for procedural assignments
always @(*) begin
    // Perform bitwise operations for AND, OR, and XOR
    out_and = &in;  // 4-input AND gate
    out_or  = |in;  // 4-input OR gate
    out_xor = ^in;  // 4-input XOR gate
end

endmodule