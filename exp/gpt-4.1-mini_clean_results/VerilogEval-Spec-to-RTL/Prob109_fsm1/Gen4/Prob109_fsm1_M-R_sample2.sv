module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;

    // Function to compute next state
    function automatic logic next_state_func(input logic curr_state, input logic in_signal);
        case (curr_state)
            B: next_state_func = (in_signal == 1'b0) ? A : B;
            A: next_state_func = (in_signal == 1'b0) ? B : A;
            default: next_state_func = B;
        endcase
    endfunction

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state_func(state, in);
    end

    // Output assigned directly from state (Moore machine output)
    assign out = (state == B) ? 1'b1 : 1'b0;

endmodule