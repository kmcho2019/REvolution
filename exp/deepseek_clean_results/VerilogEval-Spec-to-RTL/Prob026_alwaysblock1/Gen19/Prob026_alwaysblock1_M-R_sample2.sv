module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Implementation using assign statement
    assign out_assign = a & b;
    
    // Implementation using always block (now directly assigning to output)
    always @(*) begin
        out_alwaysblock = a & b;
    end
endmodule