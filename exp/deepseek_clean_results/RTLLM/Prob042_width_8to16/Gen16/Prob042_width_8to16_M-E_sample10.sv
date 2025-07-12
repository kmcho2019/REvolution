module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// State machine states
typedef enum logic {
    WAIT_FIRST,
    WAIT_SECOND
} state_t;

// Internal registers
state_t current_state;
reg [7:0] first_byte;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        current_state <= WAIT_FIRST;
        first_byte <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // Default outputs
        valid_out <= 1'b0;

        // State machine logic
        case (current_state)
            WAIT_FIRST: begin
                if (valid_in) begin
                    // Store first byte and transition to wait for second
                    first_byte <= data_in;
                    current_state <= WAIT_SECOND;
                end
            end
            
            WAIT_SECOND: begin
                if (valid_in) begin
                    // Concatenate bytes and output
                    data_out <= {first_byte, data_in};
                    valid_out <= 1'b1;
                    // Return to initial state
                    current_state <= WAIT_FIRST;
                end
            end
        endcase
    end
end

endmodule