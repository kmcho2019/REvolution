module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// State definitions
typedef enum logic [1:0] {
    IDLE,
    GOT_FIRST
} state_t;

reg [7:0] first_byte;
state_t current_state, next_state;

// State transition logic
always @(*) begin
    next_state = current_state;
    case (current_state)
        IDLE: begin
            if (valid_in)
                next_state = GOT_FIRST;
        end
        GOT_FIRST: begin
            if (valid_in)
                next_state = IDLE;
        end
    endcase
end

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        first_byte <= 8'b0;
        data_out <= 16'b0;
        valid_out <= 1'b0;
    end else begin
        current_state <= next_state;
        
        // Store first byte when transitioning to GOT_FIRST
        if (current_state == IDLE && valid_in)
            first_byte <= data_in;
            
        // Generate output when getting second byte
        valid_out <= 1'b0;
        if (current_state == GOT_FIRST && valid_in) begin
            data_out <= {first_byte, data_in};
            valid_out <= 1'b1;
        end
    end
end

endmodule