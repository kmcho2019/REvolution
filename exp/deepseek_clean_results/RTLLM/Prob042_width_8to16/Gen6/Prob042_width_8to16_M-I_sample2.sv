module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// State machine states
typedef enum logic [1:0] {
    IDLE,
    FIRST_BYTE_RECEIVED,
    OUTPUT_GENERATED
} state_t;

// Internal registers
reg [7:0] byte_holder;
state_t current_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        byte_holder <= 8'b0;
        data_out <= 16'b0;
        valid_out <= 1'b0;
    end else begin
        // Default outputs
        valid_out <= 1'b0;

        case (current_state)
            IDLE: begin
                if (valid_in) begin
                    byte_holder <= data_in;
                    current_state <= FIRST_BYTE_RECEIVED;
                end
            end
            
            FIRST_BYTE_RECEIVED: begin
                if (valid_in) begin
                    data_out <= {byte_holder, data_in};
                    valid_out <= 1'b1;
                    current_state <= OUTPUT_GENERATED;
                end else begin
                    // Stay in this state waiting for second byte
                    current_state <= FIRST_BYTE_RECEIVED;
                end
            end
            
            OUTPUT_GENERATED: begin
                // Prepare for next pair
                if (valid_in) begin
                    byte_holder <= data_in;
                    current_state <= FIRST_BYTE_RECEIVED;
                end else begin
                    current_state <= IDLE;
                end
            end
        endcase
    end
end

endmodule