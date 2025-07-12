module TopModule (
    input a,
    input b,
    output reg out
);
    always @(a or b) begin
        out = ~(a ^ b);  // XNOR implemented procedurally
    end
endmodule