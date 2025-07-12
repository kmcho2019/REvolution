module TopModule (
    input a,
    input b,
    output reg q
);
    // Combinational AND gate implementation
    always @(*) begin
        q = a & b;  // Output is 1 only when both inputs are 1
    end
endmodule