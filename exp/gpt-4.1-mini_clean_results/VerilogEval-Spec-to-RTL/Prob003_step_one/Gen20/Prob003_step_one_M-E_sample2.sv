module TopModule(
    output reg one,
    input wire clk,
    input wire rst_n  // active-low asynchronous reset
);

    // Asynchronous reset clears output to 0, but asynchronous preset sets output to 1
    // To implement preset in Verilog, we use async reset logic and initialize output to 1.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            one <= 1'b1; // asynchronously preset to 1 on reset de-assert (low)
        else
            one <= 1'b1; // hold 1 on every clock cycle (no state change)
    end

endmodule