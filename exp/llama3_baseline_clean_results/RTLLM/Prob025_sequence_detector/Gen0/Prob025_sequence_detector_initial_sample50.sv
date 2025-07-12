module sequence_detector(
    input clk, 
    input reset_n, 
    input data_in, 
    output reg sequence_detected
);

// Define the states of the FSM
enum logic [2:0] {IDLE, S1, S2, S3, S4} state, next_state;

// State machine logic
always_comb begin
    case(state)
        IDLE: 
            if (data_in == 1'b1) 
                next_state = S1;
            else 
                next_state = IDLE;
        S1: 
            if (data_in == 1'b0) 
                next_state = S2;
            else 
                next_state = IDLE;
        S2: 
            if (data_in == 1'b0) 
                next_state = S3;
            else 
                next_state = IDLE;
        S3: 
            if (data_in == 1'b1) 
                next_state = S4;
            else 
                next_state = IDLE;
        S4: 
            next_state = IDLE;
    endcase
end

// Sequence detection logic
always_comb begin
    case(state)
        S4: sequence_detected = 1'b1;
        default: sequence_detected = 1'b0;
    endcase
end

// State register
always_ff @(posedge clk, negedge reset_n) begin
    if (!reset_n) begin
        state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        state <= next_state;
    end
end

endmodule