module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Enumerate the states
typedef enum {OFF, ON} state_t;
state_t current_state, next_state;

// Output logic
assign out = (current_state == ON) ? 1'b1 : 1'b0;

// Next state logic
always_comb begin
    case (current_state)
        OFF: begin
            if (j == 1'b1) begin
                next_state = ON;
            end else begin
                next_state = OFF;
            end
        end
        ON: begin
            if (k == 1'b1) begin
                next_state = OFF;
            end else begin
                next_state = ON;
            end
        end
        default: next_state = OFF;
    endcase
end

// Sequential logic
always_ff @(posedge clk) begin
    if (reset == 1'b1) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

endmodule