module TopModule(
    input a,
    input b,
    input c,
    input d,  // Included in sensitivity list but unused
    output reg out
);
    always @(*) begin
        out = a | (~b & c);
    end
endmodule