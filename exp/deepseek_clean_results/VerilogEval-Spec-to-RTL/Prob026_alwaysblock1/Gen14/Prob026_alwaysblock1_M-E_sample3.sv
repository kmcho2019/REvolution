module TopModule (
    input a,
    input b,
    output out_assign,
    output reg out_alwaysblock
);
    // Using ternary operator for assignment
    assign out_assign = (a && b) ? 1'b1 : 1'b0;
    
    // Always block with explicit #1 delay for simulation purposes
    always @(a or b) begin
        #1;  // Unit delay for simulation visibility
        out_alwaysblock = a & b;
    end
endmodule