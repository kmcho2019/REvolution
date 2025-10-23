module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

// Define the states
typedef enum logic [1:0] {
    S0,
    S1,
    S2
} state_t;

// Current state
state_t current_state;

// Next state
state_t next_state;

// Combinational logic for the next state
always_comb begin
    case (current_state)
        S0: begin
            if (x) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if (!x) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (x) begin
                next_state = S1;
                z = 1'b1;
            end else begin
                next_state = S0;
                z = 1'b0;
            end
        end
    endcase
end

// Sequential logic for the state register
always_ff @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        current_state <= S0;
        z <= 1'b0;
    end else begin
        current_state <= next_state;
    end
end

endmodule