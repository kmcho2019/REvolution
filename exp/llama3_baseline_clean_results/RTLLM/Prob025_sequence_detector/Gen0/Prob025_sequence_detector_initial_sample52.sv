module sequence_detector(
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
} current_state, next_state;

// Initialize the sequence_detected signal to 0
initial sequence_detected = 0;

// FSM logic
always @(*) begin
    case (current_state)
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
                next_state = S1;
            end
        end
        S2: begin
            if (data_in == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = S3;
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
            sequence_detected = 1'b1;
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// Update the current state on the rising edge of the clock
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 0;
    end else begin
        current_state <= next_state;
    end
end

endmodule