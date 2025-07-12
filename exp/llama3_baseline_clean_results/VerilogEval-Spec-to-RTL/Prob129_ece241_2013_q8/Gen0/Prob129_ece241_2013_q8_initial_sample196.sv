module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define the states
typedef enum logic [1:0] {
    S0,
    S1,
    S2
} state_t;

// Current and next state
state_t current_state;
state_t next_state;

// Output logic
assign z = (current_state == S2 && x == 1);

// State machine logic
always_comb begin
    case (current_state)
        S0: begin
            if (x == 1) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if (x == 0) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (x == 1) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        default: begin
            next_state = S0;
        end
    endcase
end

// Sequential logic
always_ff @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        current_state <= S0;
    end else begin
        current_state <= next_state;
    end
end

endmodule