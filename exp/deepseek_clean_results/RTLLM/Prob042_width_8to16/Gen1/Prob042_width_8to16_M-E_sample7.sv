module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

// FSM states
typedef enum logic {
    IDLE,
    COLLECTING
} state_t;

reg [15:0] data_shift_reg;
state_t current_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        data_shift_reg <= 16'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= 1'b0;  // Default no valid output
        
        case (current_state)
            IDLE: begin
                if (valid_in) begin
                    // Store first byte in upper bits
                    data_shift_reg[15:8] <= data_in;
                    current_state <= COLLECTING;
                end
            end
            
            COLLECTING: begin
                if (valid_in) begin
                    // Store second byte in lower bits
                    data_shift_reg[7:0] <= data_in;
                    data_out <= data_shift_reg;
                    valid_out <= 1'b1;
                    current_state <= IDLE;
                end
            end
        endcase
    end
end

endmodule