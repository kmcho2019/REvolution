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

    // Function to compute next state
    function [2:0] get_next_state(input [2:0] curr_state, input w_in);
        begin
            case (curr_state)
                A: get_next_state = (w_in == 1'b0) ? B : A;
                B: get_next_state = (w_in == 1'b0) ? C : D;
                C: get_next_state = (w_in == 1'b0) ? E : D;
                D: get_next_state = (w_in == 1'b0) ? F : A;
                E: get_next_state = (w_in == 1'b0) ? E : D;
                F: get_next_state = (w_in == 1'b0) ? C : D;
                default: get_next_state = A;
            endcase
        end
    endfunction

    // Sequential state update
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= get_next_state(state, w);
    end

    // Output z is high only in states E and F
    assign z = (state == E) || (state == F);

endmodule