module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

// Define the states
enum logic [1:0] {
    IDLE,
    SEEN_1,
    SEEN_10
} state, next_state;

// Initialize the state
initial state = IDLE;

// State machine logic
always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: begin
            if (x) begin
                next_state <= SEEN_1;
            end else begin
                next_state <= IDLE;
            end
        end
        SEEN_1: begin
            if (~x) begin
                next_state <= SEEN_10;
            end else begin
                next_state <= SEEN_1;
            end
        end
        SEEN_10: begin
            if (x) begin
                next_state <= IDLE;
            end else begin
                next_state <= SEEN_10;
            end
        end
        default: next_state <= IDLE;
    endcase
end

// Output logic
assign z = (state == SEEN_10) && x;

endmodule