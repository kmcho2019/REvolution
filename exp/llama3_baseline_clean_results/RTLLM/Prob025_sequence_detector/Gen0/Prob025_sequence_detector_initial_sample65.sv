module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// Define the states
parameter IDLE = 4'd0;
parameter S1 = 4'd1;
parameter S2 = 4'd2;
parameter S3 = 4'd3;
parameter S4 = 4'd4;

// Define the current and next state
reg [3:0] current_state, next_state;

// Define the output
reg sequence_detected_reg;

// Combinational logic for the next state
always @(*) begin
    case (current_state)
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
        default: 
            next_state = IDLE;
    endcase
end

// Combinational logic for the output
always @(*) begin
    if (current_state == S4) 
        sequence_detected_reg = 1'b1;
    else 
        sequence_detected_reg = 1'b0;
end

// Sequential logic for the state machine
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) 
        current_state <= IDLE;
    else 
        current_state <= next_state;
end

// Continuous assignment for the output
assign sequence_detected = sequence_detected_reg;

endmodule