module TopModule (
    input a,
    input b,
    input c,
    output reg out
);
    always @(*) begin
        out = a | b | c;  // Same logic using procedural assignment
    end
endmodule