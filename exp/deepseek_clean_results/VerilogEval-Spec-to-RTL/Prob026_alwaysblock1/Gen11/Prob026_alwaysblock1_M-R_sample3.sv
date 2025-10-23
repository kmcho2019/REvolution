module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Direct assign implementation
    assign out_assign = a & b;
    
    // Always block implementation without intermediate register
    always @(*) begin
        out_alwaysblock = a & b;
    end
endmodule