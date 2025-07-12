module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state;

    // Function to calculate next state combinationally
    function automatic [0:0] next_state_func;
        input current_state;
        input in_signal;
        begin
            case(current_state)
                B: next_state_func = (in_signal == 1'b0) ? A : B;
                A: next_state_func = (in_signal == 1'b0) ? B : A;
                default: next_state_func = B;
            endcase
        end
    endfunction

    // Sequential block: state update and output assignment
    always @(posedge clk) begin
        if (reset) begin
            state <= B;
            out <= 1'b1; // output for B state on reset
        end else begin
            state <= next_state_func(state, in);
            // Moore output depends only on state
            case(state)
                B: out <= 1'b1;
                A: out <= 1'b0;
                default: out <= 1'b1;
            endcase
        end
    end

endmodule