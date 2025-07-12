module TopModule (
    input  wire in,     // Single-bit input signal
    output reg  out     // Single-bit output: logical negation of 'in'
);
    // Combinational logic block: output assigned as bitwise NOT of input
    always @(*) begin
        out = ~in;
    end
endmodule