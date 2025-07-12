module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

// Define the states
enum {OFF, ON} state, next_state;

// State register
always @(posedge clk) begin
    if (reset) begin
        state <= OFF; // Reset to OFF state
    end else begin
        state <= next_state; // Update state
    end
end

// Next state logic
always @(*) begin
    case (state)
        OFF: begin
            if (j) begin
                next_state = ON; // Transition to ON state when j=1
            end else begin
                next_state = OFF; // Stay in OFF state when j=0
            end
        end
        ON: begin
            if (k) begin
                next_state = OFF; // Transition to OFF state when k=1
            end else begin
                next_state = ON; // Stay in ON state when k=0
            end
        end
    endcase
end

// Output logic
always @(*) begin
    case (state)
        OFF: out = 0; // Output 0 in OFF state
        ON:  out = 1; // Output 1 in ON state
    endcase
end

endmodule