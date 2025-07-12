module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

// Define states using one-hot encoding
reg [4:0] state; // IDLE, SEEN_1, SEEN_11, SEEN_110, SEEN_1101

// Next state logic
always @(*) begin
    case (1'b1)
        state[0]: begin // IDLE state
            if (data == 1) begin
                state = 5'b0_0_0_0_1; // transition to SEEN_1 state
            end else begin
                state = 5'b1_0_0_0_0; // stay in IDLE state
            end
        end
        state[1]: begin // SEEN_1 state
            if (data == 1) begin
                state = 5'b0_0_1_0_0; // transition to SEEN_11 state
            end else begin
                state = 5'b1_0_0_0_0; // transition back to IDLE state
            end
        end
        state[2]: begin // SEEN_11 state
            if (data == 0) begin
                state = 5'b0_0_0_1_0; // transition to SEEN_110 state
            end else begin
                state = 5'b0_0_1_0_0; // stay in SEEN_11 state
            end
        end
        state[3]: begin // SEEN_110 state
            if (data == 1) begin
                state = 5'b0_0_0_0_1; // transition to SEEN_1101 state
            end else begin
                state = 5'b1_0_0_0_0; // transition back to IDLE state
            end
        end
        state[4]: begin // SEEN_1101 state
            state = 5'b0_0_0_0_1; // stay in SEEN_1101 state
        end
        default: state = 5'b1_0_0_0_0; // default to IDLE state
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        state <= 5'b1_0_0_0_0; // reset to IDLE state
        start_shifting <= 0;
    end else begin
        // Update state
        case (1'b1)
            state[4]: begin // SEEN_1101 state
                start_shifting <= 1;
            end
            default: start_shifting <= 0;
        endcase
    end
end

endmodule