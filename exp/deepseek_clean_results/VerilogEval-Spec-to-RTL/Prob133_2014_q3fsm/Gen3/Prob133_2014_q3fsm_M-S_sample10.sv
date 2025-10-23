module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg state;  // 0=A, 1=B
reg [2:0] w_history;  // Tracks last 3 w values

always @(posedge clk) begin
    if (reset) begin
        state <= 1'b0;  // State A
        w_history <= 3'b0;
        z <= 1'b0;
    end else begin
        case (state)
            1'b0: begin  // State A
                z <= 1'b0;
                if (s) begin
                    state <= 1'b1;  // Move to B
                    w_history <= {w_history[1:0], w};  // Start tracking
                end
            end
            
            1'b1: begin  // State B
                w_history <= {w_history[1:0], w};  // Shift in new w
                // Check if exactly two 1's in last 3 w's
                z <= (w_history[0] + w_history[1] + w_history[2]) == 2;
            end
        endcase
    end
end

endmodule