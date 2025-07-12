module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // AND gate using assign statement
    assign out_assign = a & b;
    
    // AND gate using combinational always block
    reg out_always;
    always @(*) begin
        out_always = a & b;
    end
    assign out_alwaysblock = out_always;
endmodule