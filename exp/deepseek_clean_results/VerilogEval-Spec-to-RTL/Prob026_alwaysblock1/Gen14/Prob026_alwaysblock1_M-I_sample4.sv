module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Direct assign implementation
    assign out_assign = a & b;
    
    // Simplified always block implementation
    always @(*) begin
        out_alwaysblock = a & b;
    end
endmodule