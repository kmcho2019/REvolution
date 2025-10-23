module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

    // Gray-coded state definitions
    localparam [2:0] 
        IDLE = 3'b000,
        S1   = 3'b001,  // Received '1'
        S2   = 3'b011,  // Received '10'
        S3   = 3'b010,  // Received '100'
        S4   = 3'b110;  // Received '1001'

    reg [2:0] current_state, next_state;
    reg prev_data;  // Track previous input for edge detection

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= IDLE;
            prev_data <= 1'b0;
        end else begin
            current_state <= next_state;
            prev_data <= data_in;
        end
    end

    always @(*) begin
        sequence_detected = 1'b0;
        next_state = current_state;

        case (current_state)
            IDLE: 
                if (data_in) next_state = S1;
            
            S1: 
                if (!data_in) next_state = S2;
                else next_state = S1;  // Stay if we get consecutive 1s
            
            S2: 
                if (!data_in) next_state = S3;
                else next_state = IDLE;  // Break sequence '100' expected
            
            S3: 
                if (data_in && !prev_data) begin  // Positive edge of final '1'
                    next_state = S4;
                    sequence_detected = 1'b1;
                end
                else if (data_in) next_state = IDLE;  // Break sequence
                else next_state = S3;  // Stay if we get consecutive 0s
            
            S4: 
                next_state = data_in ? S1 : S2;  // Start new sequence detection
            
            default: 
                next_state = IDLE;
        endcase
    end

endmodule