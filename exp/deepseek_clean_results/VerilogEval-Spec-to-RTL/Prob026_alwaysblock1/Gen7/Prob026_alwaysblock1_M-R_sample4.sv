module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Direct assign implementation
    assign out_assign = a & b;
    
    // Always block implementation
    reg out_always;
    always @(*) begin
        out_always = a & b;
    end
    assign out_alwaysblock = out_always;
endmodule