module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // AND gate using assign statement
    assign out_assign = a & b;
    
    // AND gate using always block with different style
    reg temp;
    always @(*) begin
        temp = a & b;
    end
    assign out_alwaysblock = temp;
endmodule