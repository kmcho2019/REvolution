module TopModule (
    input in,
    output out
);
    // LUT-based NOT gate implementation
    parameter [1:0] LUT = 2'b10; // NOT gate truth table
    
    reg [1:0] lut_reg;
    
    initial begin
        lut_reg = LUT; // Initialize LUT
    end
    
    assign out = lut_reg[in]; // Select output based on input
endmodule