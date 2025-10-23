module TopModule (
    output out
);
    reg clk = 0;
    reg counter = 0;
    
    always #5 clk = ~clk;  // Internal clock generation
    
    always @(posedge clk) begin
        counter <= ~counter;  // Toggle counter
    end
    
    assign out = counter & ~counter;  // Always 0 by boolean identity
endmodule