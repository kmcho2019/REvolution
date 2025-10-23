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

// State registers
state_t current_state, next_state;

// Data storage register
reg [7:0] stored_data;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= WAIT_FIRST;
        stored_data <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        current_state <= next_state;
        
        // State machine logic
        case (current_state)
            WAIT_FIRST: begin
                if (valid_in) begin
                    stored_data <= data_in;
                    valid_out <= 1'b0;
                end
            end
            
            WAIT_SECOND: begin
                if (valid_in) begin
                    data_out <= {stored_data, data_in};
                    valid_out <= 1'b1;
                end else begin
                    valid_out <= 1'b0;
                end
            end
        endcase
    end
end

// Next state logic
always_comb begin
    case (current_state)
        WAIT_FIRST: begin
            next_state = (valid_in) ? WAIT_SECOND : WAIT_FIRST;
        end
        
        WAIT_SECOND: begin
            next_state = (valid_in) ? WAIT_FIRST : WAIT_SECOND;
        end
        
        default: begin
            next_state = WAIT_FIRST;
        end
    endcase
end

endmodule