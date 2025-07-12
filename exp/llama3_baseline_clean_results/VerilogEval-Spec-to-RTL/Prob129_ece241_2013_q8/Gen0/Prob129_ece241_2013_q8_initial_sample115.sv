module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

    // Define the states
    enum logic [1:0] {S0, S1, S2} state, next_state;

    // Initialize the state
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
            z <= 0;
        end else begin
            state <= next_state;
        end
    end

    // Calculate the next state
    always @* begin
        next_state = state;
        case (state)
            S0: if (x) next_state = S1;
            S1: if (x) next_state = S1; else next_state = S2;
            S2: if (x) next_state = S1; else next_state = S0;
        endcase
    end

    // Calculate the output z
    always @* begin
        if ((state == S2) && x) z = 1'b1;
        else z = 1'b0;
    end

endmodule