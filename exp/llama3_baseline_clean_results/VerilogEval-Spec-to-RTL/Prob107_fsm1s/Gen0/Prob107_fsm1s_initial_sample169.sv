module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states of the state machine
typedef enum logic [0:0] {
    B,
    A
} state_type;

// Declare the current and next states
state_type current_state;
state_type next_state;

// Combinatorial always block to calculate the next state and output
always_comb begin
    case (current_state)
        B: begin
            if (in) begin
                next_state = B;
                out = 1'b1;
            end else begin
                next_state = A;
                out = 1'b1;
            end
        end
        A: begin
            if (in) begin
                next_state = A;
                out = 1'b0;
            end else begin
                next_state = B;
                out = 1'b0;
            end
        end
        default: begin
            next_state = B;
            out = 1'b1;
        end
    endcase
end

// Sequential always block to update the current state
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= B;
    end else begin
        current_state <= next_state;
    end
end

endmodule