module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state;
    wire next_state;

    // Combinational next state logic using a function for clarity and maintainability
    function automatic logic compute_next_state(input logic curr_state, input logic in_signal);
        case (curr_state)
            B: compute_next_state = (in_signal == 1'b0) ? A : B;
            A: compute_next_state = (in_signal == 1'b0) ? B : A;
            default: compute_next_state = B; // safe default
        endcase
    endfunction

    assign next_state = compute_next_state(state, in);

    // Output logic - Moore output depending solely on current state
    assign out = (state == B);

    // Synchronous state update with active-high reset and explicit case for robustness
    always @(posedge clk) begin
        if (reset) begin
            state <= B;
        end else begin
            state <= next_state;
        end
    end

endmodule