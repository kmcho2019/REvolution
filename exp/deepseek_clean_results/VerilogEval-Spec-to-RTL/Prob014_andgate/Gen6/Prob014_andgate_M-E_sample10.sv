module TopModule(
    input a,
    input b,
    output reg out
);
    // Clock generation for simulation purposes
    reg clk = 0;
    always #5 clk = ~clk;

    // Sequential AND implementation
    always @(posedge clk) begin
        out <= a & b;
    end

    // Initialization
    initial begin
        out = 1'b0;
    end
endmodule