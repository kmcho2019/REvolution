module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define the states of the FSM
enum logic [2:0] {
    IDLE = 3'b001,
    S1 = 3'b010,
    S2 = 3'b011,
    S3 = 3'b100,
    FOUND = 3'b101
} state, next_state;

// Set the initial state to IDLE
initial state = IDLE;

// Set start_shifting to 0 when in any state other than FOUND
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        start_shifting <= (state == FOUND)? 1 : 0;
    end
end

// Define the next state logic
always @(*) begin
    case(state)
        IDLE: begin
            if (data) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
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
            if (!data) begin
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
            next_state = FOUND;
        end
    endcase
end

endmodule