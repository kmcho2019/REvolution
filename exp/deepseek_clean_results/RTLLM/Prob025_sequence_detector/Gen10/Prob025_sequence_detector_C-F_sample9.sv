module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

// Hybrid approach: 3-bit shift register + optimized state machine
reg [2:0] shift_reg;
reg [1:0] state; // 2-bit state encoding

// State definitions
localparam [1:0] IDLE         = 2'b00;
localparam [1:0] PARTIAL_MATCH = 2'b01; // Detected "10"
localparam [1:0] FULL_MATCH    = 2'b10; // Sequence detected

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 3'b0;
        state <= IDLE;
        sequence_detected <= 1'b0;
    end
    else begin
        // Update shift register
        shift_reg <= {shift_reg[1:0], data_in};
        
        // Default assignments
        sequence_detected <= 1'b0;
        
        case (state)
            IDLE: begin
                // Transition to PARTIAL_MATCH when we see "10" pattern
                if (shift_reg[1:0] == 2'b10 && data_in == 1'b0)
                    state <= PARTIAL_MATCH;
            end
            
            PARTIAL_MATCH: begin
                // Check for final '1' to complete "1001" sequence
                if (data_in) begin
                    state <= FULL_MATCH;
                    sequence_detected <= 1'b1;
                end
                else begin
                    // Stay in PARTIAL_MATCH if we see another '0'
                    state <= (shift_reg[1:0] == 2'b10 && data_in == 1'b0) ? 
                            PARTIAL_MATCH : IDLE;
                end
            end
            
            FULL_MATCH: begin
                // Return to IDLE after detection
                state <= IDLE;
            end
        endcase
    end
end

endmodule