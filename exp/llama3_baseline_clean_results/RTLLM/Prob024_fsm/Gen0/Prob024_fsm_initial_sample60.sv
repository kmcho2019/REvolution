module fsm (
    input  logic IN, 
    input  logic CLK, 
    input  logic RST, 
    output logic MATCH
);

// Define the states of the FSM
typedef enum logic [2:0] {
    idle,
    s1,
    s2,
    s3,
    s4,
    s5
} state_t;

// Initialize the current state and next state
state_t current_state, next_state;

// Assign the initial value of MATCH to 0
assign MATCH = (current_state == s5) ? 1 : 0;

// FSM state machine
always_comb begin
    case (current_state)
        idle: begin
            if (IN == 1) next_state = s1;
            else next_state = idle;
        end
        s1: begin
            if (IN == 0) next_state = s2;
            else next_state = s1;
        end
        s2: begin
            if (IN == 0) next_state = s3;
            else next_state = idle;
        end
        s3: begin
            if (IN == 1) next_state = s4;
            else next_state = idle;
        end
        s4: begin
            if (IN == 1) next_state = s5;
            else next_state = idle;
        end
        s5: begin
            if (IN == 1) next_state = s5;
            else next_state = idle;
        end
    endcase
end

// Sequential logic for state transitions
always_ff @(posedge CLK or posedge RST) begin
    if (RST) current_state <= idle;
    else current_state <= next_state;
end

endmodule