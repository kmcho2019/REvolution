module TopModule (
    input x,
    input y,
    output z
);
    // Optimal combinational implementation
    assign z = x & ~y;
    
    // Verification assertion (synthesis will ignore this)
    always @(*) begin
        if ({x,y} == 2'b00) assert(z == 0);
        if ({x,y} == 2'b01) assert(z == 0);
        if ({x,y} == 2'b10) assert(z == 1);
        if ({x,y} == 2'b11) assert(z == 0);
    end
endmodule