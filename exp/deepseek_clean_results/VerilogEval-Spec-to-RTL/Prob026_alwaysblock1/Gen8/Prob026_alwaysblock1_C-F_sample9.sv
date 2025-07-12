module TopModule (
    input a,
    input b,
    output out_assign,
    output reg out_alwaysblock
);
    // Continuous assignment implementation of AND gate
    // Direct wiring with minimal overhead
    assign out_assign = a & b;
    
    // Combinational always block implementation of AND gate
    // Using blocking assignment for clear combinational behavior
    always @(*) begin
        out_alwaysblock = a & b;
    end
endmodule