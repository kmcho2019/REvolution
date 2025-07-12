module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // State encoding
    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    reg [1:0] state;

    // Function for next state logic
    function [1:0] next_state_func;
        input [1:0] current_state;
        input       in_signal;
        begin
            case (current_state)
                A: next_state_func = (in_signal) ? B : A;
                B: next_state_func = (in_signal) ? B : C;
                C: next_state_func = (in_signal) ? D : A;
                D: next_state_func = (in_signal) ? B : C;
                default: next_state_func = A;
            endcase
        end
    endfunction

    // Sequential logic: state and output registers update synchronously
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            out <= 1'b0;
        end else begin
            state <= next_state_func(state, in);
            // Moore output depends only on current state before update, so use next state to determine output
            // For synchronous output, assign output based on next state after update
            out <= (next_state_func(state, in) == D);
        end
    end

endmodule