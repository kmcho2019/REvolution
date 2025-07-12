module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Direct assign implementation (most efficient)
    assign out_assign = a & b;
    
    // Always block implementation (optimized version)
    always @(*) begin
        out_alwaysblock = a & b;
    end
endmodule