module TopModule(
    input  clk,
    input  reset,
    input  w,
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

    // Next state logic as a function
    function [2:0] next_state_func;
        input [2:0] cur_state;
        input w_in;
        begin
            case (cur_state)
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

    wire [2:0] next_state;
    assign next_state = next_state_func(state, w);

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic as continuous assignment
    assign z = (state == E) || (state == F);

endmodule