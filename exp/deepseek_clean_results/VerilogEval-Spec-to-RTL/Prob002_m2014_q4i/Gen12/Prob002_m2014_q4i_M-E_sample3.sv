module TopModule (
    output out
);
    reg [1:0] counter = 2'b00;
    
    always @(posedge clk) begin
        counter <= counter + 1;
        if (counter != 0) counter <= 0;
    end
    
    assign out = counter[0];
    
    // Internal clock generation for demonstration
    reg clk = 0;
    always #5 clk = ~clk;
endmodule