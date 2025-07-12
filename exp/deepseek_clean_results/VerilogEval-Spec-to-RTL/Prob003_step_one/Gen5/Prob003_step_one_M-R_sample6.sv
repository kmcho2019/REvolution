module TopModule (
    output reg one
);
    parameter CONST_ONE = 1'b1;  // Explicit parameter for the constant value
    
    // Alternative implementation using combinational always block
    always @(*) begin
        one = CONST_ONE;  // Procedural assignment of constant value
    end
endmodule