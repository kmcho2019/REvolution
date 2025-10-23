module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define the states of the FSM
enum logic [2:0] {
    IDLE = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100
} state, next_state;

// State machine logic
always_comb begin
    case (state)
        IDLE: begin
            if (data_in == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (data_in == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = IDLE;
            end
        end
        S2: begin
            if (data_in == 1'b0) begin
                next_state = S3;
            end else begin
                next_state = IDLE;
            end
        end
        S3: begin
            if (data_in == 1'b1) begin
                next_state = S4;
            end else begin
                next_state = IDLE;
            end
        end
        S4: begin
            next_state = IDLE;
            sequence_detected = 1'b1; // Set sequence_detected high in this state
        end
        default: next_state = IDLE;
    endcase
end

// State machine update
always_ff @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        state <= IDLE;
        sequence_detected <= 1'b0; // Reset sequence_detected on reset
    end else begin
        state <= next_state;
        if (state == S4) begin
            sequence_detected <= 1'b1;
        end else begin
            sequence_detected <= 1'b0;
        end
    end
end

endmodule