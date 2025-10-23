module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0 - state A, 1 - state B
reg [2:0] w_history; // 3-bit shift register to store the history of w

always @(posedge clk) begin
    if(reset) begin
        state <= 0;
        w_history <= 0;
        z <= 0;
    end
    else begin
        case(state)
            0: begin // state A
                if(s) begin
                    state <= 1;
                end
            end
            1: begin // state B
                // Shift the history of w
                w_history <= {w, w_history[2:1]};
                // Check if we have three cycles of w history
                if(w_history!= 0 && w_history[2] == 0) begin
                    // Count the number of 1s in w_history
                    if((w_history[0] + w_history[1] + w_history[2]) == 2) begin
                        z <= 1;
                    end
                    else begin
                        z <= 0;
                    end
                    // Reset w_history for the next three cycles
                    w_history <= 0;
                end
            end
            default: state <= 0;
        endcase
    end
end

endmodule