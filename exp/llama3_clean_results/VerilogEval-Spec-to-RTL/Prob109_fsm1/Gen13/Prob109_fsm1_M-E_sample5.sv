module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    logic [1:0] state; // One-hot encoded state (A=2'b01, B=2'b10)

    // Sequential logic with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b10; // Asynchronously reset to state B
        end else begin
            case (1'b1)
                state[0]: state <= in? 2'b01 : 2'b10;
                state[1]: state <= in? 2'b10 : 2'b01;
            endcase
        end
    end

    // Directly assign output based on the state
    assign out = state[1];

endmodule