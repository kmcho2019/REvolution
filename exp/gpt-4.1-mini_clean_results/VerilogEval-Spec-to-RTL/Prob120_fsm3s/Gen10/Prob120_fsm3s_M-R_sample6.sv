module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    reg [1:0] state;

    // Function for next state logic
    function [1:0] next_state_func;
        input [1:0] current_state;
        input in_signal;
        begin
            case (current_state)
                A: next_state_func = (in_signal == 1'b0) ? A : B;
                B: next_state_func = (in_signal == 1'b0) ? C : B;
                C: next_state_func = (in_signal == 1'b0) ? A : D;
                D: next_state_func = (in_signal == 1'b0) ? C : B;
                default: next_state_func = A;
            endcase
        end
    endfunction

    // Function for output logic (Moore)
    function out_func;
        input [1:0] current_state;
        begin
            out_func = (current_state == D) ? 1'b1 : 1'b0;
        end
    endfunction

    // Sequential logic: state update on positive clock edge with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state_func(state, in);
    end

    // Output logic: continuous assignment from function
    assign out = out_func(state);

endmodule