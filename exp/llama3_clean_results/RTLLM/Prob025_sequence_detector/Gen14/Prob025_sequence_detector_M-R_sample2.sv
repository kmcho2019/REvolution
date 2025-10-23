module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output reg      sequence_detected
);

// Define the states using an enumeration
enum logic [2:0] {IDLE, S1, S2, S3, S4} state, next_state;

// Define the sequence length
parameter SEQUENCE_LENGTH = 4;

// Define the expected sequence
parameter SEQUENCE [SEQUENCE_LENGTH-1:0] = 4'b1001;

// Initialize the state machine and output on reset
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        state <= next_state;
    end
end

// State transition logic
always @(*) begin
    case (state)
        IDLE: begin
            if (data_in == SEQUENCE[0]) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (data_in == SEQUENCE[1]) begin
                next_state = S2;
            end else begin
                next_state = IDLE;
            end
        end
        S2: begin
            if (data_in == SEQUENCE[2]) begin
                next_state = S3;
            end else begin
                next_state = IDLE;
            end
        end
        S3: begin
            if (data_in == SEQUENCE[3]) begin
                next_state = S4;
            end else begin
                next_state = IDLE;
            end
        end
        S4: begin
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// Output generation
always @(posedge clk) begin
    if (state == S4) begin
        sequence_detected <= 1'b1;
    end else begin
        sequence_detected <= 1'b0;
    end
end

endmodule