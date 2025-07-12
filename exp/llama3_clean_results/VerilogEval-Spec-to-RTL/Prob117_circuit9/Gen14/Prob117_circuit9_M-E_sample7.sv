module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

// Define the states
enum logic [1:0] {
    IDLE,
    INCREMENT,
    RESET
} state, next_state;

// Combinational logic for next state
always @(*) begin
    case(state)
        IDLE: begin
            if (a) begin
                next_state = IDLE;
            end else begin
                next_state = INCREMENT;
            end
        end
        INCREMENT: begin
            if (a) begin
                next_state = RESET;
            end else if (q < 6) begin
                next_state = INCREMENT;
            end else begin
                next_state = IDLE; // After reaching 6, wrap around to 4 (handled in sequential logic)
            end
        end
        RESET: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// Sequential logic for state transition and output update
always @(posedge clk) begin
    state <= next_state;
    case(state)
        IDLE: q <= 4;
        INCREMENT: begin
            if (q < 6) begin
                q <= q + 1;
            end else begin
                q <= 0; // Wrap around to 0 after reaching 6
            end
        end
        RESET: q <= 4;
        default: q <= 4;
    endcase
end

// Initialize the state and output
initial begin
    state = IDLE;
    q = 4;
end

endmodule