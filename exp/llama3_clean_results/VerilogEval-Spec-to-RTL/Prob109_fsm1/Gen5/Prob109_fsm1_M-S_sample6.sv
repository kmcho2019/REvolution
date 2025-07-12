module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    // Define the states directly for simplicity
    reg state;

    // Sequential logic with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1; // Asynchronously reset to state B
        end else begin
            case (state)
                0: state <= in? 0 : 1; // State A transitions
                1: state <= in? 1 : 0; // State B transitions
            endcase
        end
    end

    // Directly assign output based on the state
    assign out = state;

endmodule