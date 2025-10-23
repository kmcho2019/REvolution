module TopModule (
    input wire a,       // Explicit wire declaration
    input wire b,       // Explicit wire declaration
    output wire out_assign,     // AND implemented with assign
    output reg out_alwaysblock  // AND implemented with always
);
    // Implementation 1: Continuous assignment (pure combinational)
    assign out_assign = a & b;
    
    // Implementation 2: Always block (combinational)
    always @(*) begin
        out_alwaysblock = a & b;
    end
endmodule