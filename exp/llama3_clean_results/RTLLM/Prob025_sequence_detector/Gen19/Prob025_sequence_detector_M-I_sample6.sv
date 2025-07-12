module sequence_detector(
    input           clk,
    input           rst_n,
    input           data_in,
    output          sequence_detected
);

// Define the states
enum logic [1:0] {
    IDLE,
    S1,
    S2,
    S3
} state, next_state;

// Control logic
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (state)
        IDLE: begin
            if (data_in) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (~data_in) begin
                next_state = S2;
            end else begin
                next_state = IDLE;
            end
        end
        S2: begin
            if (~data_in) begin
                next_state = S3;
            end else begin
                next_state = IDLE;
            end
        end
        S3: begin
            if (data_in) begin
                next_state = IDLE; // Directly go back to IDLE and assert output
                sequence_detected = 1'b1;
            end else begin
                next_state = IDLE;
                sequence_detected = 1'b0;
            end
        end
        default: next_state = IDLE;
    endcase
end

// Output logic
assign sequence_detected = (state == S3 && data_in);

endmodule