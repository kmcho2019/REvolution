module TopModule (
    output out
);
    // Internal toggle signals
    reg [1:0] toggle = 2'b00;
    reg clk = 0;
    
    // Clock generation
    always #5 clk = ~clk;
    
    // Toggle generation
    always @(posedge clk) begin
        toggle <= toggle + 1;
    end
    
    // 2-bit LUT programmed to always output 0
    assign out = (toggle == 2'b00) ? 1'b0 :
                 (toggle == 2'b01) ? 1'b0 :
                 (toggle == 2'b10) ? 1'b0 :
                 1'b0;
endmodule