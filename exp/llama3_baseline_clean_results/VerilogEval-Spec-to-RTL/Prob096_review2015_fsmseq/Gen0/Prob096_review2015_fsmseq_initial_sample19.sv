module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

// Define the states of the finite-state machine
enum logic [2:0] {Idle, S1, S2, S3, S4} state, next_state;

// Initialize the state
initial state = Idle;

// Main logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= Idle;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        case (state)
            Idle: begin
                if (data == 1) next_state <= S1;
                else next_state <= Idle;
            end
            S1: begin
                if (data == 1) next_state <= S2;
                else if (data == 0) next_state <= Idle;
                else next_state <= S1;
            end
            S2: begin
                if (data == 0) next_state <= S3;
                else if (data == 1) next_state <= S1;
                else next_state <= S2;
            end
            S3: begin
                if (data == 1) next_state <= S4;
                else if (data == 0) next_state <= Idle;
                else next_state <= S3;
            end
            S4: begin
                next_state <= S4;
                start_shifting <= 1;
            end
            default: next_state <= Idle;
        endcase
    end
end

endmodule