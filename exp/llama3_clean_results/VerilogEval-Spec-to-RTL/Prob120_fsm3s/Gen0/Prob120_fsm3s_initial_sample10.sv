module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define the states
typedef enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state_t;

// Current state
state_t current_state;
state_t next_state;

// Output logic
always_comb begin
    case (current_state)
        A: out = 1'b0;
        B: out = 1'b0;
        C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'bx;
    endcase
end

// State transition logic
always_comb begin
    case (current_state)
        A: begin
            if (!in) next_state = A;
            else next_state = B;
        end
        B: begin
            if (!in) next_state = C;
            else next_state = B;
        end
        C: begin
            if (!in) next_state = A;
            else next_state = D;
        end
        D: begin
            if (!in) next_state = C;
            else next_state = B;
        end
        default: next_state = A;
    endcase
end

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule