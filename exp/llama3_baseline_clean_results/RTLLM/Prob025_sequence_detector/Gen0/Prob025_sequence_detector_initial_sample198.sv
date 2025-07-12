module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// Define states as an enum
typedef enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} state_t;

state_t current_state, next_state;

// Combinational logic to determine next state
always_comb begin
    case(current_state)
        IDLE: 
            if(data_in) 
                next_state = S1;
            else 
                next_state = IDLE;
        S1: 
            if(~data_in) 
                next_state = S2;
            else 
                next_state = IDLE;
        S2: 
            if(data_in) 
                next_state = S3;
            else 
                next_state = IDLE;
        S3: 
            if(~data_in) 
                next_state = S4;
            else 
                next_state = IDLE;
        S4: 
            next_state = IDLE;
        default: 
            next_state = IDLE;
    endcase
end

// Sequential logic to update state and output
always_ff @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        current_state <= next_state;
        if (current_state == S4) 
            sequence_detected <= 1'b1;
        else 
            sequence_detected <= 1'b0;
    end
end

endmodule