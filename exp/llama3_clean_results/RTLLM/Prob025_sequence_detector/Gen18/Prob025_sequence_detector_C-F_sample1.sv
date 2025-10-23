module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output          sequence_detected
);

// Define the states
enum logic [1:0] {
    IDLE = 2'b00,
    S1   = 2'b01,
    S2   = 2'b10,
    S3   = 2'b11
} state, next_state;

// State machine logic
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
                next_state = IDLE;
            end else begin
                next_state = IDLE;
            end
        end
        default: next_state = IDLE;
    endcase
end

// Output logic
assign sequence_detected = (state == S3 && data_in == 1'b1);

endmodule