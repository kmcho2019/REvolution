module TopModule(
    input a,
    input b,
    output reg out
);
    // Internal clock for dynamic operation
    reg clk = 0;
    always #5 clk = ~clk;  // 10 time unit clock period

    // Dynamic NOR implementation
    always @(posedge clk or negedge clk) begin
        if (~clk) begin
            // Pre-charge phase
            out <= 1'b1;
        end else begin
            // Evaluation phase
            if (a || b) out <= 1'b0;
            // else maintains pre-charged value
        end
    end
endmodule