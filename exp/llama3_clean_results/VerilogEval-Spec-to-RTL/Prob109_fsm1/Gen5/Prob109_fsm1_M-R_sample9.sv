module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    // Define the states using an enum for readability
    enum logic [0:0] {
        A = 0,
        B = 1
    } state, nextState;

    // Combinational logic for next state
    always_comb begin
        case (state)
            A: nextState = in ? A : B;
            B: nextState = in ? B : A;
        endcase
    end

    // Sequential logic with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B; // Asynchronously reset to state B
        end else begin
            state <= nextState;
        end
    end

    // Directly assign output based on the state
    assign out = state;

endmodule