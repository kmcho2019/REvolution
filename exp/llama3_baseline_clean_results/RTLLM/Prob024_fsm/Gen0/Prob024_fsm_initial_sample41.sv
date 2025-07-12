module fsm(
    input IN,  // Input signal to the FSM
    input CLK,  // Clock signal used for synchronous operation
    input RST,  // Reset signal to initialize the FSM
    output reg MATCH  // Output signal indicating a match condition based on the FSM state
);

// Define the states
parameter S0 = 4'd0,
           S1 = 4'd1,
           S2 = 4'd2,
           S3 = 4'd3,
           S4 = 4'd4,
           S5 = 4'd5;

reg [3:0] current_state, next_state;

// Initialize the current state
initial current_state = S0;

// State transition logic
always @(*) begin
    case (current_state)
        S0: begin
            if (IN) next_state = S1;
            else next_state = S0;
        end
        S1: begin
            if (!IN) next_state = S2;
            else next_state = S1;
        end
        S2: begin
            if (!IN) next_state = S3;
            else next_state = S1;
        end
        S3: begin
            if (IN) next_state = S4;
            else next_state = S0;
        end
        S4: begin
            if (IN) next_state = S5;
            else next_state = S0;
        end
        S5: begin
            if (IN) next_state = S5;
            else next_state = S0;
        end
        default: next_state = S0;
    endcase
end

// Output logic
always @(*) begin
    if (current_state == S5 && IN) MATCH = 1;
    else MATCH = 0;
end

// Update the current state on the positive edge of the clock
always @(posedge CLK) begin
    if (RST) current_state <= S0;
    else current_state <= next_state;
end

endmodule