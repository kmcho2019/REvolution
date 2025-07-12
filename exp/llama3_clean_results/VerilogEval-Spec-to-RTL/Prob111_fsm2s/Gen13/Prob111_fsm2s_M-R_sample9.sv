module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

typedef enum logic [0:0] {
    OFF,
    ON
} state_t;

state_t state, next_state;

// State register with synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        state <= OFF; // Reset to OFF state
    end else begin
        state <= next_state; // Update state based on next state logic
    end
end

// Next state and output logic
always_comb begin
    case (state)
        OFF: begin
            next_state = j ? ON : OFF;
            out = 1'b0;
        end
        ON: begin
            next_state = ~k ? ON : OFF;
            out = 1'b1;
        end
    endcase
end

endmodule