module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Define states as an enumeration
enum logic [0:0] {OFF, ON} state, next_state;

// Sequential logic for state update
always_ff @(posedge clk) begin
    if (reset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

// Combinatorial logic for next state and output
always_comb begin
    case (state)
        OFF: begin
            if (j) begin
                next_state = ON;
            end else begin
                next_state = OFF;
            end
        end
        ON: begin
            if (k) begin
                next_state = OFF;
            end else begin
                next_state = ON;
            end
        end
        default: next_state = OFF;
    endcase
    // Output logic based on current state
    case (state)
        OFF: out = 0;
        ON:  out = 1;
        default: out = 0;
    endcase
end

endmodule