module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

// Define states
enum logic [0:0] {OFF, ON} state, next_state;

// Combinational logic for next state
always_comb begin
    case (state)
        OFF: begin
            if (j) next_state = ON;
            else next_state = OFF;
        end
        ON: begin
            if (k) next_state = OFF;
            else next_state = ON;
        end
        default: next_state = OFF;
    endcase
end

// Sequential logic for state update and output
always_ff @(posedge clk) begin
    if (reset) begin
        state <= OFF;
        out <= 0;
    end
    else begin
        state <= next_state;
        case (state)
            OFF: out <= 0;
            ON: out <= 1;
            default: out <= 0;
        endcase
    end
end

endmodule