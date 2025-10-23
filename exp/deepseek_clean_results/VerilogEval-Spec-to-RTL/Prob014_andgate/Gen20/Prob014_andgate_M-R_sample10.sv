module TopModule(
    input a,
    input b,
    output reg out
);
    always @(a or b) begin
        out = a & b;  // Procedural implementation of AND gate
    end
endmodule