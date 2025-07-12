module TopModule (
    input  a,
    input  b,
    input  c,
    output reg out
);
    // Use an always_comb block for combinational logic
    always @(*) begin
        out = a | b | c;
    end
endmodule