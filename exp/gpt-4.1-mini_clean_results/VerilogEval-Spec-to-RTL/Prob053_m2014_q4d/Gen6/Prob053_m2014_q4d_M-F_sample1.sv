module TopModule (
    input  clk,
    input  in,
    output out
);

    reg state_reg;
    wire next_state;

    assign next_state = in ^ state_reg;

    always @(posedge clk) begin
        state_reg <= next_state;
    end

    // Initialize state_reg to 0 for simulation only; no reset in hardware
    initial begin
        state_reg = 1'b0;
    end

    assign out = state_reg;

endmodule