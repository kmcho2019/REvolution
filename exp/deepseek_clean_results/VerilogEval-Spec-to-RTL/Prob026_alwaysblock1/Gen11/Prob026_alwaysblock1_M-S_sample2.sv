module TopModule (
    input a,
    input b,
    output out_assign,
    output reg out_alwaysblock
);
    // Simple assign implementation
    assign out_assign = a & b;
    
    // Combinational always block implementation
    always @(*) begin
        out_alwaysblock = a & b;
    end
endmodule