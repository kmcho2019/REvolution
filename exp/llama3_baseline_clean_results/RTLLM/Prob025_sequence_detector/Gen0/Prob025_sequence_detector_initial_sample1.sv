module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Enum for states
typedef enum logic [1:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} state_t;

// Initialize state register
state_t state;

// Sequence detection
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        state <= IDLE;
        sequence_detected <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in == 1) state <= S1;
                else state <= IDLE;
            end
            S1: begin
                if (data_in == 0) state <= S2;
                else state <= IDLE;
            end
            S2: begin
                if (data_in == 0) state <= S3;
                else state <= IDLE;
            end
            S3: begin
                if (data_in == 1) state <= S4;
                else state <= IDLE;
            end
            S4: begin
                sequence_detected <= 1;
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
end

// Set sequence_detected low after one clock cycle
always @(posedge clk) begin
    if (state != S4) sequence_detected <= 0;
end

endmodule