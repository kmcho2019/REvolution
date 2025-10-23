module TopModule (
    input a,
    input b,
    output reg out
);
    always @(*) begin
        out = ~(a ^ b);  // Same XNOR logic using procedural assignment
    end
endmodule