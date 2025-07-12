module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
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

    // Function for next state calculation
    function [2:0] next_state_func;
        input [2:0] curr_state;
        input w_in;
        begin
            case(curr_state)
                A: next_state_func = (w_in == 0) ? B : A;
                B: next_state_func = (w_in == 0) ? C : D;
                C: next_state_func = (w_in == 0) ? E : D;
                D: next_state_func = (w_in == 0) ? F : A;
                E: next_state_func = (w_in == 0) ? E : D;
                F: next_state_func = (w_in == 0) ? C : D;
                default: next_state_func = A;
            endcase
        end
    endfunction

    // Sequential block: state update and output generation
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 1'b0;
        end else begin
            state <= next_state_func(state, w);
            z <= (state == E) || (state == F);
        end
    end

endmodule