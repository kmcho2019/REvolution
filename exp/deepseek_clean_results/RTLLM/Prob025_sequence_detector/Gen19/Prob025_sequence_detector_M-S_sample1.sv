module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

typedef enum {
    IDLE,
    S1,    // Got '1'
    S2,    // Got '10'
    S3     // Got '100'
} state_t;

state_t current_state;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        sequence_detected <= 1'b0;  // Default output
        
        case (current_state)
            IDLE: 
                if (data_in) current_state <= S1;
            
            S1: 
                if (!data_in) current_state <= S2;
                else current_state <= S1;  // Stay if we get another '1'
            
            S2: 
                if (!data_in) current_state <= S3;
                else current_state <= S1;  // Restart if we get '1' after '10'
            
            S3: 
                if (data_in) begin
                    sequence_detected <= 1'b1;
                    current_state <= S1;  // Restart detection
                end else begin
                    current_state <= IDLE;  // Reset if pattern breaks
                end
        endcase
    end
end

endmodule