module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    // Use a reg type for the state to emphasize it's a sequential element
    reg state; // Current state (A=0, B=1)

    // Sequential logic with asynchronous reset, explicitly define the state update based on current state and input
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1; // Asynchronously reset to state B
        end else begin
            unique case (state)
                1'b0: state <= in ? 1'b0 : 1'b1;
                1'b1: state <= in ? 1'b1 : 1'b0;
                default: state <= 1'b1; // Default to state B for any unexpected state value
            endcase
        end
    end

    // Directly assign output based on the state, ensuring minimal logic for output calculation
    assign out = state;

endmodule