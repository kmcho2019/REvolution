module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define states
enum logic [2:0] { IDLE, S1, S2, S3, S4 } state, next_state;

// Initialize output
initial sequence_detected = 0;

// State register
always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        state <= IDLE;
    else
        state <= next_state;
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: begin
            if (data_in == 1)
                next_state = S1;
            else
                next_state = IDLE;
        end
        S1: begin
            if (data_in == 0)
                next_state = S2;
            else
                next_state = IDLE;
        end
        S2: begin
            if (data_in == 0)
                next_state = S3;
            else
                next_state = IDLE;
        end
        S3: begin
            if (data_in == 1)
                next_state = S4;
            else
                next_state = IDLE;
        end
        S4: begin
            next_state = IDLE;
        end
    endcase
end

// Sequence detection
always @(posedge clk) begin
    if (state == S4) begin
        sequence_detected <= 1;
    end else begin
        sequence_detected <= 0;
    end
end

endmodule