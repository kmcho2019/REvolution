module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Enumerate the states
typedef enum logic [1:0] {
    A,
    B,
    C,
    D
} state_t;

// Declare the current and next state
state_t current_state, next_state;

// Sequential logic for state transition
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic for next state and output
always_comb begin
    case (current_state)
        A: begin
            if (~in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
            out = 0;
        end
        B: begin
            if (~in) begin
                next_state = C;
            end else begin
                next_state = B;
            end
            out = 0;
        end
        C: begin
            if (~in) begin
                next_state = A;
            end else begin
                next_state = D;
            end
            out = 0;
        end
        D: begin
            if (~in) begin
                next_state = C;
            end else begin
                next_state = B;
            end
            out = 1;
        end
    endcase
end

endmodule