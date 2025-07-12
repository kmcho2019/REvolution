module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define the states of the FSM
enum logic [2:0] {
    IDLE = 3'b000,
    S1   = 3'b001,
    S2   = 3'b010,
    S3   = 3'b011,
    S4   = 3'b100
} state, next_state;

// Define the desired sequence
localparam DESIRED_SEQ = 4'b1001;

// Combinational logic to determine the next state
always_comb begin
    case(state)
        IDLE: 
            if(data_in == DESIRED_SEQ[3]) 
                next_state = S1;
            else 
                next_state = IDLE;
        S1: 
            if(data_in == DESIRED_SEQ[2]) 
                next_state = S2;
            else 
                next_state = IDLE;
        S2: 
            if(data_in == DESIRED_SEQ[1]) 
                next_state = S3;
            else 
                next_state = IDLE;
        S3: 
            if(data_in == DESIRED_SEQ[0]) 
                next_state = S4;
            else 
                next_state = IDLE;
        S4: 
            next_state = IDLE;
    endcase
end

// Sequential logic to update the current state
always_ff @(posedge clk, negedge reset_n) begin
    if(~reset_n) 
        state <= IDLE;
    else 
        state <= next_state;
end

// Set sequence_detected high when the sequence is detected
always_ff @(posedge clk) begin
    if(state == S4) 
        sequence_detected <= 1'b1;
    else 
        sequence_detected <= 1'b0;
end

endmodule