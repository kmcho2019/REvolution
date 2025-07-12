module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

// Define states
typedef enum logic [1:0] {
    S0,
    S1,
    S2
} state_t;

state_t current_state, next_state;

// State register
always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        current_state <= S0;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
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
            if (~x) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (x) begin
                next_state = S1; // Since we've seen '101', we go back to S1
                // and z will be asserted high in this clock cycle
            end else begin
                next_state = S0;
            end
        end
        default: next_state = S0;
    endcase
end

// Output logic
assign z = (current_state == S2) && x;

endmodule