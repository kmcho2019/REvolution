module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // AND gate using assign statement
    assign out_assign = a & b;
    
    // AND gate using always block (combinational)
    always @(*) begin
        out_alwaysblock = a & b;
    end
endmodule