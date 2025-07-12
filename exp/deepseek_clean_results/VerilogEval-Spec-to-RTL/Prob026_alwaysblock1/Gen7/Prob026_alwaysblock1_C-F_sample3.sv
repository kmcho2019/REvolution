module TopModule (
    input a,
    input b,
    output out_assign,
    output reg out_alwaysblock
);
    // Continuous assignment implementation of AND gate
    assign out_assign = a & b;
    
    // Combinational always block implementation of AND gate
    // Using blocking assignment for combinational logic
    always @(*) begin
        out_alwaysblock = a & b;
    end
endmodule