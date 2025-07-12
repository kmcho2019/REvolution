module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// Define the states of the FSM
parameter IDLE = 4'd0;
parameter S1 = 4'd1;
parameter S2 = 4'd2;
parameter S3 = 4'd3;
parameter S4 = 4'd4;

// Current state and next state
reg [3:0] current_state;
reg [3:0] next_state;

// Sequence detection output
reg sequence_detected_reg;

always @(*) begin
    // Default next state is the current state
    next_state = current_state;
    
    // State transitions based on the current state and input data
    case (current_state)
        IDLE: 
            if (data_in == 1'b1) begin
                next_state = S1;
            end
        S1: 
            if (data_in == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = IDLE;
            end
        S2: 
            if (data_in == 1'b0) begin
                next_state = S3;
            end else begin
                next_state = IDLE;
            end
        S3: 
            if (data_in == 1'b1) begin
                next_state = S4;
            end else begin
                next_state = IDLE;
            end
        S4: 
            next_state = IDLE;
    endcase
end

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        // Reset the FSM to the IDLE state
        current_state <= IDLE;
        sequence_detected_reg <= 1'b0;
    end else begin
        // Update the current state and sequence detection output
        current_state <= next_state;
        if (next_state == S4) begin
            sequence_detected_reg <= 1'b1;
        end else begin
            sequence_detected_reg <= 1'b0;
        end
    end
end

assign sequence_detected = sequence_detected_reg;

endmodule