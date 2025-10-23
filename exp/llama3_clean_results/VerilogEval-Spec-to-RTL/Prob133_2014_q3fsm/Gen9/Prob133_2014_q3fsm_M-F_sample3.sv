module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0: State A, 1: State B
reg [2:0] w_history; // Shift register to store 'w' history for the last three clock cycles

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 0;
        w_history <= 0;
        z <= 0;
    end else begin
        case(state)
            0: begin // State A
                if(s) begin
                    state <= 1;
                end
            end
            1: begin // State B
                w_history <= {w, w_history[2:1]}; // Shift 'w' into the history
                // Count the number of high bits in 'w_history'
                if(w_history[2] + w_history[1] + w_history[0] == 2) begin
                    z <= 1;
                end else begin
                    z <= 0;
                end
            end
        endcase
    end
end

endmodule