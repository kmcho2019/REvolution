module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Continuous assignment implementation
    assign out_assign = a & b;
    
    // Combinational always block implementation
    always @(a or b) begin
        out_alwaysblock = a & b;
    end
endmodule