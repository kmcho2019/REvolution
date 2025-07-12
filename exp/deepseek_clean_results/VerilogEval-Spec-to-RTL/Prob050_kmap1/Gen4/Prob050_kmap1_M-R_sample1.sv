module TopModule (
    input a,
    input b,
    input c,
    output reg out
);
    always @(a or b or c) begin
        out = a | b | c;
    end
endmodule