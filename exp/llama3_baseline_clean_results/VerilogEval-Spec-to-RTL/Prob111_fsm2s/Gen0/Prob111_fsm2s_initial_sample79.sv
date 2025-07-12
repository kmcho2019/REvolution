module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Define states
enum logic [0:0] {OFF, ON} current_state, next_state;

// Clocked always block for state update and reset
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

// Combinational always block for next state calculation
always_comb begin
    case (current_state)
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
        default: begin
            next_state = OFF;
        end
    endcase
end

// Output logic
always_comb begin
    case (current_state)
        OFF: out = 0;
        ON: out = 1;
        default: out = 0;
    endcase
end

endmodule