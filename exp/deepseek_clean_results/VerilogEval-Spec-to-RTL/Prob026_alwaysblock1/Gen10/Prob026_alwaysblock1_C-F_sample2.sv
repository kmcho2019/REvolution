module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Direct assign implementation - simplest and most efficient
    assign out_assign = a & b;
    
    // Clean always block implementation without intermediate register
    always @(*) begin
        out_alwaysblock = a & b;
    end
endmodule