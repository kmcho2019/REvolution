module TopModule (
    input  clk,
    input  in,
    output reg out
);

    reg state_reg;

    always @(posedge clk) begin
        // Compute next state as XOR of input and current state
        state_reg <= in ^ state_reg;
        // Output follows the registered state
        out <= state_reg;
    end

endmodule