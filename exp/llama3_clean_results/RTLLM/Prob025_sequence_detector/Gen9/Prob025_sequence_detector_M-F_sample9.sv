module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output reg      sequence_detected
);

// Define the states as an enum
typedef enum logic [1:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} state_t;

// Declare the current state
state_t current_state;

// Initial state
initial current_state = IDLE;

// State machine logic
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        case (current_state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    current_state <= S1;
                end else begin
                    current_state <= IDLE;
                end
                sequence_detected <= 1'b0;
            end
            S1: begin
                if (data_in == 1'b0) begin
                    current_state <= S2;
                end else begin
                    current_state <= IDLE;
                end
                sequence_detected <= 1'b0;
            end
            S2: begin
                if (data_in == 1'b0) begin
                    current_state <= S3;
                end else begin
                    current_state <= IDLE;
                end
                sequence_detected <= 1'b0;
            end
            S3: begin
                if (data_in == 1'b1) begin
                    current_state <= S4;
                    sequence_detected <= 1'b1;
                end else begin
                    current_state <= IDLE;
                    sequence_detected <= 1'b0;
                end
            end
            S4: begin
                current_state <= IDLE;
                sequence_detected <= 1'b0;
            end
            default: begin
                current_state <= IDLE;
                sequence_detected <= 1'b0;
            end
        endcase
    end
end

endmodule