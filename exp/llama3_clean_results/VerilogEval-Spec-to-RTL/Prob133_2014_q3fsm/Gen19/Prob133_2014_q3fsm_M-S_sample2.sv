module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [2:0] cnt; // Counter for '1's in the last three 'w' values
reg state; // Current state (0: waiting for s, 1: examining w)

always @(posedge clk) begin
    if(reset) begin
        state <= 0;
        cnt <= 0;
        z <= 0;
    end
    else begin
        case(state)
            0: begin
                // Transition from state 0 to state 1 when s = 1
                if(s) begin
                    state <= 1;
                    cnt <= w;
                end
                else begin
                    state <= 0;
                    cnt <= 0;
                end
            end
            1: begin
                // Shift 'w' value into the counter
                cnt <= {w, cnt[2:1]};
                // If three cycles have passed, update 'z' and reset 'cnt'
                if(cnt[2] == 1'b1) begin
                    z <= (cnt == 3'b110) || (cnt == 3'b101) || (cnt == 3'b011);
                    cnt <= w;
                end
                // Stay in state 1
                state <= 1;
            end
        endcase
    end
end

endmodule