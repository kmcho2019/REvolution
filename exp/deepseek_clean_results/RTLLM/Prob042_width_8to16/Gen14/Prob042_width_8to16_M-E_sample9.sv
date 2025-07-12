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

reg [15:0] shift_reg;
state_t current_state;

always @(posedge clk) begin
    if (!rst_n) begin
        shift_reg <= 16'b0;
        current_state <= WAIT_FIRST;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= 1'b0;  // Default no valid output
        
        case (current_state)
            WAIT_FIRST: begin
                if (valid_in) begin
                    shift_reg[15:8] <= data_in;
                    current_state <= WAIT_SECOND;
                end
            end
            
            WAIT_SECOND: begin
                if (valid_in) begin
                    shift_reg[7:0] <= data_in;
                    data_out <= shift_reg;
                    valid_out <= 1'b1;
                    current_state <= WAIT_FIRST;
                end
            end
        endcase
    end
end

endmodule