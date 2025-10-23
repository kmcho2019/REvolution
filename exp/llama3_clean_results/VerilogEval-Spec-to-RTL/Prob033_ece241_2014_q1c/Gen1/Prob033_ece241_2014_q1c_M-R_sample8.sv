module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output reg overflow
);

    always @(*) begin
        // Perform the addition
        s = a + b;
        
        // Detect overflow
        if (a[7] == b[7] && a[7] != s[7]) begin
            overflow = 1'b1; // Overflow occurred
        end else begin
            overflow = 1'b0; // No overflow
        end
    end

endmodule