module TopModule (
    output out
);
    reg clk = 0;
    always #5 clk = ~clk;  // Free-running clock (value doesn't matter)
    
    assign out = 1'b0 & clk;  // AND with 0 ensures output is always 0
endmodule