module TopModule (
    input in,
    output out
);
    // NOT gate implementation using procedural assignment
    // Demonstrates alternative coding style with identical functionality
    reg out_reg;
    
    always @(*) begin
        out_reg = ~in;
    end
    
    assign out = out_reg;
endmodule