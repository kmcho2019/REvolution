module TopModule (
    input a,
    input b,
    output out_assign,
    output reg out_alwaysblock
);
    // Simple continuous assignment for first output
    assign out_assign = a & b;
    
    // Combinational always block for second output
    always @(*) begin
        out_alwaysblock = a & b;
    end
endmodule