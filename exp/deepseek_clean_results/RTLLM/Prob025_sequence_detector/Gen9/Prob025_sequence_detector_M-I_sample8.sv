module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

// Optimized state encoding
typedef enum logic [1:0] {
    IDLE,
    GOT1,
    GOT10,
    GOT100
} state_t;

state_t current_state, next_state;
reg [1:0] prev_bits;  // Stores previous two bits
reg shift_enable;     // Enable signal for shift register

// State transition logic
always @(*) begin
    next_state = current_state;
    shift_enable = 1'b0;
    
    case (current_state)
        IDLE: begin
            if (data_in == 1'b1) begin
                next_state = GOT1;
                shift_enable = 1'b1;
            end
        end
        
        GOT1: begin
            shift_enable = 1'b1;
            if (data_in == 1'b0)
                next_state = GOT10;
            else
                next_state = GOT1;  // Stay if we get consecutive 1's
        end
        
        GOT10: begin
            shift_enable = 1'b1;
            if (data_in == 1'b0)
                next_state = GOT100;
            else
                next_state = IDLE;  // Pattern broken
        end
        
        GOT100: begin
            if (data_in == 1'b1) begin
                sequence_detected = 1'b1;
                next_state = IDLE;
            end else begin
                next_state = GOT10;  // Continue matching
            end
        end
    endcase
end

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        prev_bits <= 2'b0;
        sequence_detected <= 1'b0;
    end else begin
        current_state <= next_state;
        
        // Conditional shift register update
        if (shift_enable) begin
            prev_bits <= {prev_bits[0], data_in};
        end
        
        // Registered output
        if (current_state == GOT100 && data_in == 1'b1)
            sequence_detected <= 1'b1;
        else
            sequence_detected <= 1'b0;
    end
end

endmodule