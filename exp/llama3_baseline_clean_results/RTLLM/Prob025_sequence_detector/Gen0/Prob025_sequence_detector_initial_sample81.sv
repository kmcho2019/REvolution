module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define the states of the FSM
enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} state, next_state;

// Default output
always @(*) begin
    sequence_detected = 1'b0;
end

// State machine logic
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: begin
            if (data_in == 1'b1) begin
                next_state <= S1;
            end else begin
                next_state <= IDLE;
            end
        end
        S1: begin
            if (data_in == 1'b0) begin
                next_state <= S2;
            end else begin
                next_state <= IDLE;
            end
        end
        S2: begin
            if (data_in == 1'b0) begin
                next_state <= S3;
            end else begin
                next_state <= IDLE;
            end
        end
        S3: begin
            if (data_in == 1'b1) begin
                next_state <= S4;
            end else begin
                next_state <= IDLE;
            end
        end
        S4: begin
            sequence_detected = 1'b1;
            next_state <= IDLE;
        end
        default: next_state <= IDLE;
    endcase
end

endmodule