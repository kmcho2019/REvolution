module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

// Explicitly define the states
enum logic [0:0] {OFF, ON} state, next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= OFF; // Reset to OFF state
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        OFF: begin
            if (j == 1) begin
                next_state = ON; // Transition to ON state
            end else begin
                next_state = OFF; // Stay in OFF state
            end
        end
        ON: begin
            if (k == 1) begin
                next_state = OFF; // Transition to OFF state
            end else begin
                next_state = ON; // Stay in ON state
            end
        end
        default: next_state = OFF; // Default to OFF state
    endcase
end

// Assign output based on current state
always @(*) begin
    case (state)
        OFF: out = 0;
        ON: out = 1;
        default: out = 0; // Default output to 0
    endcase
end

endmodule