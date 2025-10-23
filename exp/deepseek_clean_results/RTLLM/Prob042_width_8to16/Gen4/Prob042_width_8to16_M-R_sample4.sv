module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// State definitions
typedef enum logic {
    WAIT_FIRST,
    WAIT_SECOND
} state_t;

state_t current_state;
reg [7:0] stored_byte;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= WAIT_FIRST;
        stored_byte <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= 1'b0; // Default no valid output
        
        case (current_state)
            WAIT_FIRST: begin
                if (valid_in) begin
                    stored_byte <= data_in;
                    current_state <= WAIT_SECOND;
                end
            end
            
            WAIT_SECOND: begin
                if (valid_in) begin
                    data_out <= {stored_byte, data_in};
                    valid_out <= 1'b1;
                    current_state <= WAIT_FIRST;
                end
            end
        endcase
    end
end

endmodule