module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// Intermediate signal for XOR operation between a and b
wire ab_xor = (a & ~b) | (~a & b);

// Using a case statement to define the output based on c, d, and ab_xor
always @(*) begin
    case ({c, d})
        2'b00: out = ab_xor;
        2'b01: out = ~ab_xor;
        2'b11: out = ab_xor;
        2'b10: out = ~ab_xor;
    endcase
end

endmodule