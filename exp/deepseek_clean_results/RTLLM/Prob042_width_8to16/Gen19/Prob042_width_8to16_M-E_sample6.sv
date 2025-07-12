module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// State encoding
typedef enum logic [1:0] {
    IDLE,
    GOT_FIRST_BYTE,
    OUTPUT
} state_t;

reg [1:0] current_state, next_state;
reg [7:0] stored_byte;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        stored_byte <= 8'b0;
        data_out <= 16'b0;
        valid_out <= 1'b0;
    end else begin
        current_state <= next_state;
        
        // State-specific operations
        case (current_state)
            IDLE: begin
                if (valid_in) begin
                    stored_byte <= data_in;
                end
                valid_out <= 1'b0;
            end
            
            GOT_FIRST_BYTE: begin
                if (valid_in) begin
                    data_out <= {stored_byte, data_in};
                end
                valid_out <= 1'b0;
            end
            
            OUTPUT: begin
                valid_out <= 1'b1;
            end
        endcase
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE: begin
            next_state = valid_in ? GOT_FIRST_BYTE : IDLE;
        end
        
        GOT_FIRST_BYTE: begin
            next_state = valid_in ? OUTPUT : GOT_FIRST_BYTE;
        end
        
        OUTPUT: begin
            next_state = IDLE;
        end
        
        default: begin
            next_state = IDLE;
        end
    endcase
end

endmodule