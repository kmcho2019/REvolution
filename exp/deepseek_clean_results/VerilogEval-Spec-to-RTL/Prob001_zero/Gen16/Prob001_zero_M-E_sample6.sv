module TopModule (
    output zero
);
    reg toggle = 0;
    
    always @(*) begin
        toggle = ~toggle;
    end
    
    assign zero = toggle & ~toggle;
endmodule