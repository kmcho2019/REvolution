module TopModule(
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] s,
    output reg overflow
);
    always @(*) begin
        // Perform the addition
        s = a + b;
        
        // Detect overflow: occurs when inputs have same sign but result has different sign
        overflow = (a[7] == b[7]) && (a[7] != s[7]);
    end
endmodule