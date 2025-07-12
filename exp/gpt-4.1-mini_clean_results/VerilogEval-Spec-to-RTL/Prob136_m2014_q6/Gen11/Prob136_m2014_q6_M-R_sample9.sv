module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

    // State encoding
    localparam [2:0]
        A = 3'd0,
        B = 3'd1,
        C = 3'd2,
        D = 3'd3,
        E = 3'd4,
        F = 3'd5;

    reg [2:0] state;

    // Next state function
    function [2:0] next_state_func;
        input [2:0] curr_state;
        input       w_in;
        begin
            case (curr_state)
                A: next_state_func = (w_in == 1'b0) ? B : A;
                B: next_state_func = (w_in == 1'b0) ? C : D;
                C: next_state_func = (w_in == 1'b0) ? E : D;
                D: next_state_func = (w_in == 1'b0) ? F : A;
                E: next_state_func = (w_in == 1'b0) ? E : D;
                F: next_state_func = (w_in == 1'b0) ? C : D;
                default: next_state_func = A;
            endcase
        end
    endfunction

    // Sequential state update
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state_func(state, w);
    end

    // Output logic: z = 1 if state is E or F
    // Since E=4 (100), F=5 (101), the MSB is 1 for both; we can assign z = state[2]
    assign z = state[2];

endmodule