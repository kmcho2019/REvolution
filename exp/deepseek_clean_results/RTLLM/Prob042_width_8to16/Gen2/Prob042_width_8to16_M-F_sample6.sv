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
    COLLECT
} state_t;

reg [7:0] first_byte;
reg [7:0] second_byte;
state_t current_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        first_byte <= 8'b0;
        second_byte <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= 1'b0;  // Default no valid output
        
        case (current_state)
            IDLE: begin
                if (valid_in) begin
                    first_byte <= data_in;
                    current_state <= COLLECT;
                end
            end
            
            COLLECT: begin
                if (valid_in) begin
                    second_byte <= data_in;
                    data_out <= {first_byte, data_in};
                    valid_out <= 1'b1;
                    current_state <= IDLE;
                end
                // Stay in COLLECT state if no valid input
                // until next valid input arrives
            end
        endcase
    end
end

endmodule