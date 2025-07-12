module TopModule (
    input a,
    input b,
    input c,
    output reg out
);
    // Behavioral implementation using always block
    always @(*) begin
        out = a | b | c;
    end
endmodule