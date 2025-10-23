module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // LUT parameters for AND function
    parameter [0:3] AND_LUT = {1'b0, 1'b0, 1'b0, 1'b1};
    
    // Assign implementation using LUT
    assign out_assign = AND_LUT[{a, b}];
    
    // Always block implementation using case statement
    always @(*) begin
        case ({a, b})
            2'b00: out_alwaysblock = 1'b0;
            2'b01: out_alwaysblock = 1'b0;
            2'b10: out_alwaysblock = 1'b0;
            2'b11: out_alwaysblock = 1'b1;
        endcase
    end
endmodule