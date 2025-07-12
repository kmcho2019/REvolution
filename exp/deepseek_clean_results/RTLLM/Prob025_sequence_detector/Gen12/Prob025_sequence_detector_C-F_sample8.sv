module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// State definitions
typedef enum logic [1:0] {
    IDLE = 2'b00,
    S1   = 2'b01,  // Received '1'
    S2   = 2'b10,  // Received '10'
    S3   = 2'b11   // Received '100'
} state_t;

// Internal signals
state_t state, next_state;
reg [2:0] shift_reg;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= IDLE;
        shift_reg <= 3'b0;
        sequence_detected <= 1'b0;
    end
    else begin
        state <= next_state;
        shift_reg <= {shift_reg[1:0], data_in};
        
        // Output is high only when we detect the full sequence
        sequence_detected <= (state == S3) && data_in;
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: begin
            next_state = data_in ? S1 : IDLE;
        end
        
        S1: begin
            next_state = data_in ? S1 : S2;  // '1' followed by '0'
        end
        
        S2: begin
            next_state = data_in ? S1 : S3;  // '10' followed by '0'
        end
        
        S3: begin
            next_state = data_in ? IDLE : S2;  // Reset or continue
        end
        
        default: next_state = IDLE;
    endcase
end

endmodule