module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] cnt_w; // Counter for '1's in the last three 'w' values
reg [1:0] cycle_cnt; // Counter for the current cycle within the three-cycle window
reg state; // Current state (0: waiting for s, 1: examining w)

always @(posedge clk) begin
    if(reset) begin
        state <= 0;
        cnt_w <= 0;
        cycle_cnt <= 0;
        z <= 0;
    end
    else begin
        case(state)
            0: begin
                // Transition from state 0 to state 1 when s = 1
                if(s) begin
                    state <= 1;
                    cnt_w <= w;
                    cycle_cnt <= 1;
                end
                else begin
                    state <= 0;
                    cnt_w <= 0;
                    cycle_cnt <= 0;
                end
            end
            1: begin
                // Increment the cycle counter
                cycle_cnt <= cycle_cnt + 1;
                // Update the counter for '1's in 'w'
                cnt_w <= cnt_w + w;
                // If three cycles have passed, update 'z' and reset counters
                if(cycle_cnt == 2'd3) begin
                    z <= (cnt_w == 2);
                    cnt_w <= w;
                    cycle_cnt <= 1;
                end
                // Stay in state 1
                state <= 1;
            end
        endcase
    end
end

endmodule