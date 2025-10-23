module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// Define states
typedef enum logic [1:0] {
    IDLE,
    FIRST_BYTE_RECEIVED
} state_t;

reg [7:0] first_byte_reg;
state_t current_state, next_state;

// State transition logic
always @(posedge clk) begin
    if (!rst_n) begin
        current_state <= IDLE;
        first_byte_reg <= 8'b0;
    end else begin
        current_state <= next_state;
        
        // Store first byte when valid in IDLE state
        if (valid_in && current_state == IDLE) begin
            first_byte_reg <= data_in;
        end
    end
end

// Next state logic
always_comb begin
    next_state = current_state;
    case (current_state)
        IDLE: begin
            if (valid_in) begin
                next_state = FIRST_BYTE_RECEIVED;
            end
        end
        FIRST_BYTE_RECEIVED: begin
            if (valid_in) begin
                next_state = IDLE;
            end
        end
    endcase
end

// Output generation with pipeline register
always @(posedge clk) begin
    if (!rst_n) begin
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= 1'b0;
        
        if (current_state == FIRST_BYTE_RECEIVED && valid_in) begin
            data_out <= {first_byte_reg, data_in};
            valid_out <= 1'b1;
        end
    end
end

endmodule