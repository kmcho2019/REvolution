module TopModule(
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] s,
    output reg overflow
);
    always @(*) begin
        // Perform the addition
        s = a + b;
        
        // Detect signed overflow
        overflow = (~a[7] & ~b[7] & s[7]) |  // Positive + Positive = Negative
                   (a[7] & b[7] & ~s[7]);    // Negative + Negative = Positive
    end
endmodule