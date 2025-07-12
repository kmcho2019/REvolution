module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [3:0] state; // 0: IDLE, 1: SEEN_1, 2: SEEN_11, 3: SEEN_110, 4: SEEN_1101

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // reset to IDLE state
        start_shifting <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (data == 1) begin
                    state <= 1; // transition to SEEN_1 state
                end
            end
            1: begin // SEEN_1 state
                if (data == 1) begin
                    state <= 2; // transition to SEEN_11 state
                end else begin
                    state <= 0; // transition back to IDLE state
                end
            end
            2: begin // SEEN_11 state
                if (data == 0) begin
                    state <= 3; // transition to SEEN_110 state
                end else begin
                    state <= 2; // stay in SEEN_11 state
                end
            end
            3: begin // SEEN_110 state
                if (data == 1) begin
                    state <= 4; // transition to SEEN_1101 state
                end else begin
                    state <= 0; // transition back to IDLE state
                end
            end
            4: begin // SEEN_1101 state
                start_shifting <= 1; // set start_shifting to 1
            end
            default: state <= 0; // default to IDLE state
        endcase
    end
end

endmodule