module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

// Define the states
enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    FOUND
} state, next_state;

// Output logic
logic start_shifting_next;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 1'b0;
    end else begin
        state <= next_state;
        start_shifting <= start_shifting_next;
    end
end

always_comb begin
    next_state = state;
    start_shifting_next = start_shifting;

    case (state)
        IDLE: begin
            if (data) begin
                next_state = S1;
            end
        end
        S1: begin
            if (data) begin
                next_state = S2;
            end else begin
                next_state = IDLE;
            end
        end
        S2: begin
            if (~data) begin
                next_state = S3;
            end else begin
                next_state = S1;
            end
        end
        S3: begin
            if (data) begin
                next_state = FOUND;
            end else begin
                next_state = IDLE;
            end
        end
        FOUND: begin
            start_shifting_next = 1'b1;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

endmodule