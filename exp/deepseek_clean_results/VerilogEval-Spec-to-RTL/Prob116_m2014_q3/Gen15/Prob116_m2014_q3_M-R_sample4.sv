module TopModule(
    input [3:0] x,  // x[3:0] maps to x[4:1] in K-map
    output reg f
);
    wire term1, term2;
    
    assign term1 = ~x[0] & x[2];    // First AND term
    assign term2 = x[0] & x[1] & x[3]; // Second AND term
    
    always @(*) begin
        f = term1 | term2;  // OR combination of terms
    end
endmodule