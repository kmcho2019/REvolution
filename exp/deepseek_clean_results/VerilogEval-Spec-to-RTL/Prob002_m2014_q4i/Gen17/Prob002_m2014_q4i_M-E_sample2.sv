module TopModule (
    output reg out
);
    always @(posedge clk) begin
        out <= 1'b0;
    end

    // Internal clock generation for demonstration
    // In real implementation, this would be an input port
    reg clk = 0;
    always #5 clk = ~clk;
endmodule