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
    IDLE,
    GOT_FIRST_BYTE
} state_t;

reg [7:0] first_byte_reg;
state_t current_state, next_state;

// State transition logic
always @(*) begin
    next_state = current_state;
    case (current_state)
        IDLE: begin
            if (valid_in) next_state = GOT_FIRST_BYTE;
        end
        GOT_FIRST_BYTE: begin
            if (valid_in) next_state = IDLE;
        end
    endcase
end

// Sequential logic (state and registers)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        first_byte_reg <= 8'b0;
        data_out <= 16'b0;
        valid_out <= 1'b0;
    end else begin
        current_state <= next_state;
        
        // Capture first byte when transitioning to GOT_FIRST_BYTE
        if (valid_in && current_state == IDLE) begin
            first_byte_reg <= data_in;
        end
        
        // Generate output when completing the pair
        valid_out <= 1'b0;
        if (valid_in && current_state == GOT_FIRST_BYTE) begin
            data_out <= {first_byte_reg, data_in};
            valid_out <= 1'b1;
        end
    end
end

endmodule