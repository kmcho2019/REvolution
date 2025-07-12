module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output reg      sequence_detected
);

// Define states for the FSM using one-hot encoding
enum logic [3:0] {
    IDLE = 4'b0001,
    S1   = 4'b0010,
    S2   = 4'b0100,
    S3   = 4'b1000
} state, next_state;

// Current state register
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
                next_state = IDLE;
            end else begin
                next_state = IDLE;
            end
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// Output assignment
always @(posedge clk) begin
    if (state == S3 && data_in == 1'b1) begin
        sequence_detected <= 1'b1;
    end else begin
        sequence_detected <= 1'b0;
    end
end

endmodule