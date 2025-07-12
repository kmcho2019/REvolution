module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // State encoding
    localparam A = 3'd0,
               B = 3'd1,
               C = 3'd2,
               D = 3'd3,
               E = 3'd4,
               F = 3'd5;

    reg [2:0] state, next_state;

    // Sequential logic: state flip-flops with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Function for next state logic
    function [2:0] get_next_state;
        input [2:0] curr_state;
        input w_in;
        begin
            case (curr_state)
                A: get_next_state = w_in ? B : A;
                B: get_next_state = w_in ? C : D;
                C: get_next_state = w_in ? E : D;
                D: get_next_state = w_in ? F : A;
                E: get_next_state = w_in ? E : D;
                F: get_next_state = w_in ? C : D;
                default: get_next_state = A;
            endcase
        end
    endfunction

    // Combinational assignment for next state
    always @(*) begin
        next_state = get_next_state(state, w);
    end

    // Output logic: z asserted in states E or F using continuous assignment
    assign z = (state == E) || (state == F);

endmodule