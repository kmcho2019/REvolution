module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Define states
typedef enum logic [0:0] {
    OFF,
    ON
} State;

// Register to hold current state
State current_state;
State next_state;

// Output logic based on current state
always_comb begin
    case (current_state)
        OFF: out = 1'b0;
        ON:  out = 1'b1;
        default: out = 1'b0; // default output for invalid states
    endcase
end

// Combinational logic to determine next state
always_comb begin
    case (current_state)
        OFF: begin
            if (j == 1'b1)
                next_state = ON;
            else
                next_state = OFF;
        end
        ON: begin
            if (k == 1'b1)
                next_state = OFF;
            else
                next_state = ON;
        end
        default: next_state = OFF; // default next state for invalid current states
    endcase
end

// Sequential logic to update current state
always_ff @(posedge clk) begin
    if (reset == 1'b1) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

endmodule