module sequence_detector(
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

// Define the current state and next state
reg [3:0] current_state;
reg [3:0] next_state;

// Define the sequence to be detected
parameter SEQUENCE = 4'b1001;

// Define the sequence detection output
reg sequence_detected_reg;

always @(*) begin
    // Initialize the next state to the current state
    next_state = current_state;
    
    // Check the current state and transition to the next state based on the input data_in
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
            if (data_in == 1'b1) 
                next_state = S1;
            else 
                next_state = IDLE;
    endcase
end

always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        // Reset the state machine to the IDLE state
        current_state <= IDLE;
        sequence_detected_reg <= 1'b0;
    end else begin
        // Update the current state and sequence detection output
        current_state <= next_state;
        if (current_state == S4) begin
            sequence_detected_reg <= 1'b1;
        end else begin
            sequence_detected_reg <= 1'b0;
        end
    end
end

// Assign the sequence detection output
assign sequence_detected = sequence_detected_reg;

endmodule