module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define states for each prefix of the target sequence
enum logic [2:0] {
    IDLE = 3'b000,
    STATE_1 = 3'b001,
    STATE_11 = 3'b010,
    STATE_110 = 3'b011,
    STATE_1101 = 3'b100
} state;

// Initialize the FSM to the IDLE state
initial state = IDLE;
initial start_shifting = 0;

reg sequence_found;

always @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        sequence_found <= 0;
        start_shifting <= 0;
    end else begin
        case(state)
            IDLE: begin
                if(data == 1'b1) begin
                    state <= STATE_1;
                end
            end
            STATE_1: begin
                if(data == 1'b1) begin
                    state <= STATE_11;
                end else begin
                    state <= IDLE;
                end
            end
            STATE_11: begin
                if(data == 1'b0) begin
                    state <= STATE_110;
                end else begin
                    state <= STATE_11;
                end
            end
            STATE_110: begin
                if(data == 1'b1) begin
                    state <= STATE_1101;
                end else begin
                    state <= IDLE;
                end
            end
            STATE_1101: begin
                sequence_found <= 1;
                // Stay in this state once sequence is found
            end
            default: state <= IDLE;
        endcase
    end
    // Set start_shifting based on the sequence_found flag
    if (sequence_found) begin
        start_shifting <= 1;
    end else begin
        start_shifting <= 0;
    end
end

endmodule