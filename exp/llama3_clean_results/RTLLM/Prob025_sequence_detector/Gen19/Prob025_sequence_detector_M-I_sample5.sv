module sequence_detector(
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

// Enumerate states for the sequence detection
enum logic [1:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} state, next_state;

// FSM logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        sequence_detected <= 0;
    end else begin
        state <= next_state;
        if (next_state == S4) begin
            sequence_detected <= 1;
        end else begin
            sequence_detected <= 0;
        end
    end
end

// Next state logic
always @(*) begin
    case(state)
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
        end
        default: next_state = IDLE;
    endcase
end

endmodule