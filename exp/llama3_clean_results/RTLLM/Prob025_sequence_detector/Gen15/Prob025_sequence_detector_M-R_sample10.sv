module sequence_detector(
    input           clk,
    input           rst_n,
    input           data_in,
    output          sequence_detected
);

// Define states
enum logic [1:0] {
    IDLE,
    S1,
    S2,
    S3
} state, next_state;

// State transition logic
always_comb begin
    case (state)
        IDLE: begin
            if (data_in == 1'b1) next_state = S1;
            else next_state = IDLE;
        end
        S1: begin
            if (data_in == 1'b0) next_state = S2;
            else next_state = IDLE;
        end
        S2: begin
            if (data_in == 1'b0) next_state = S3;
            else next_state = IDLE;
        end
        S3: begin
            if (data_in == 1'b1) next_state = IDLE;
            else next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// State register
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Output logic
assign sequence_detected = (state == S3 && data_in == 1'b1);

endmodule