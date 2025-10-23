module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State A = 2'b00, State B = 2'b01
reg [1:0] cnt;   // Counter for clock cycles in State B
reg w_cnt;       // Counter for w = 1 occurrences in State B

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 2'b00; // Reset to State A
        cnt <= 2'b00;
        w_cnt <= 1'b0;
        z <= 1'b0;
    end else begin
        case(state)
            2'b00: begin // State A
                if(s) begin
                    state <= 2'b01; // Transition to State B
                    cnt <= 2'b00;
                    w_cnt <= 1'b0;
                end else begin
                    state <= 2'b00; // Stay in State A
                end
            end
            2'b01: begin // State B
                cnt <= cnt + 1'b1;
                if(w) begin
                    w_cnt <= w_cnt + 1'b1;
                end
                if(cnt == 2'b11) begin // After 3 clock cycles
                    if(w_cnt == 2'b10) begin // Exactly 2 w = 1 occurrences
                        z <= 1'b1;
                    end else begin
                        z <= 1'b0;
                    end
                    state <= 2'b01; // Stay in State B
                    cnt <= 2'b00;
                    w_cnt <= 1'b0;
                end
            end
            default: begin
                state <= 2'b00;
            end
        endcase
    end
end

endmodule