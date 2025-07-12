module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [2:0] w_history; // Shift register to track 'w' history
reg state; // Current state (A or B)

always @(posedge clk) begin
    if(reset) begin
        state <= 1'b0; // Reset to state A
        w_history <= 3'b000; // Reset shift register
        z <= 0; // Reset output
    end
    else begin
        case(state)
            1'b0: begin // State A
                if(s) begin
                    state <= 1'b1; // Transition to state B
                end
                else begin
                    state <= 1'b0; // Stay in state A
                end
                z <= 0; // 'z' is 0 in state A
            end
            1'b1: begin // State B
                // Shift 'w' into the history register
                w_history <= {w, w_history[2:1]};
                
                // Count the number of 1's in the history register
                z <= (w_history == 3'b001 || w_history == 3'b010 || w_history == 3'b100);
            end
        endcase
    end
end

endmodule