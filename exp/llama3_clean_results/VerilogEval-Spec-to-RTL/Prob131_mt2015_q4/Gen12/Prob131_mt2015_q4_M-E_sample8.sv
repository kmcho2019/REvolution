module IntegratedModule(x, y, z);
    input x, y;
    output z;
    
    // Directly compute the output z based on the conditions of x and y
    always @(x or y) begin
        case ({x, y})
            2'b00: z = 1'b1; // Both x and y are 0
            2'b01: z = 1'b0; // x is 0, y is 1
            2'b10: z = 1'b0; // x is 1, y is 0
            2'b11: z = 1'b1; // Both x and y are 1
        endcase
    end
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    
    IntegratedModule integrated_module(x, y, z);
endmodule