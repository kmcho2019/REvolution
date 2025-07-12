module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

// Use one-hot encoding for states
reg [4:0] state; // 1: IDLE, 2: SEEN_1, 4: SEEN_11, 8: SEEN_110, 16: SEEN_1101
reg [4:0] next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // reset to IDLE state
        start_shifting <= 0;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (1'b1)
        state[0]: begin // IDLE state
            if (data == 1) begin
                next_state = 4'b0010; // transition to SEEN_1 state
            end else begin
                next_state = 4'b0001; // stay in IDLE state
            end
        end
        state[1]: begin // SEEN_1 state
            if (data == 1) begin
                next_state = 4'b0100; // transition to SEEN_11 state
            end else begin
                next_state = 4'b0001; // transition back to IDLE state
            end
        end
        state[2]: begin // SEEN_11 state
            if (data == 0) begin
                next_state = 4'b1000; // transition to SEEN_110 state
            end else begin
                next_state = 4'b0100; // stay in SEEN_11 state
            end
        end
        state[3]: begin // SEEN_110 state
            if (data == 1) begin
                next_state = 4'b1000; // transition to SEEN_1101 state and set start_shifting
                start_shifting <= 1;
            end else begin
                next_state = 4'b0001; // transition back to IDLE state
            end
        end
        default: next_state = 4'b0001; // default to IDLE state
    endcase
end

endmodule