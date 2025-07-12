module sequence_detector(
    input clk, 
    input reset_n, 
    input data_in, 
    output reg sequence_detected
);

// Define the states of the FSM
typedef enum logic [2:0] {
    IDLE = 3'b001, 
    S1 = 3'b010, 
    S2 = 3'b011, 
    S3 = 3'b100, 
    S4 = 3'b101
} state_type;

// Declare the current and next states
reg [2:0] current_state, next_state;

// Initialize the current state to IDLE
initial current_state = IDLE;

// Define the FSM transitions
always @(*) begin
    case (current_state)
        IDLE: 
            if (data_in == 1'b1) 
                next_state = IDLE;
            else if (data_in == 1'b0) 
                next_state = S1;
            else 
                next_state = IDLE;
        S1: 
            if (data_in == 1'b0) 
                next_state = S1;
            else if (data_in == 1'b0) 
                next_state = S1;
            else if (data_in == 1'b1) 
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
        default: 
            next_state = IDLE;
    endcase
end

// Update the current state on the rising edge of the clock
always @(posedge clk or negedge reset_n) begin
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