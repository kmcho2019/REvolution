module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;
    reg [1:0] cycle_cnt;
    reg [1:0] w_count;

    // Next state logic as functions for clarity
    function [0:0] next_state_func;
        input current_state;
        input s_in;
        begin
            case (current_state)
                A: next_state_func = s_in ? B : A;
                B: next_state_func = B;
                default: next_state_func = A;
            endcase
        end
    endfunction

    // Next counters logic as functions
    function [1:0] next_cycle_cnt_func;
        input current_state;
        input [1:0] curr_cycle_cnt;
        begin
            if (current_state == B) begin
                next_cycle_cnt_func = (curr_cycle_cnt == 2) ? 2'b00 : curr_cycle_cnt + 1'b1;
            end else begin
                next_cycle_cnt_func = 2'b00;
            end
        end
    endfunction

    function [1:0] next_w_count_func;
        input current_state;
        input [1:0] curr_w_count;
        input w_in;
        input [1:0] curr_cycle_cnt;
        begin
            if (current_state == B) begin
                // Reset count at cycle_cnt==2, else accumulate
                next_w_count_func = (curr_cycle_cnt == 2) ? 2'b00 : (curr_w_count + w_in);
            end else begin
                next_w_count_func = 2'b00;
            end
        end
    endfunction

    // Output logic computed combinationally to register z at clock edge
    // z is set to 1 at the clock after completing 3rd cycle if exactly two w=1s were counted
    wire z_next;
    assign z_next = (state == B && cycle_cnt == 2 && (w_count == 2)) ? 1'b1 : 1'b0;

    // Sequential logic: update state, counters, and output
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'b00;
            w_count <= 2'b00;
            z <= 1'b0;
        end else begin
            state <= next_state_func(state, s);
            cycle_cnt <= next_cycle_cnt_func(state, cycle_cnt);
            w_count <= next_w_count_func(state, w_count, w, cycle_cnt);
            z <= z_next;
        end
    end

endmodule