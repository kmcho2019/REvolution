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
    HAVE_FIRST_BYTE
} state_t;

reg [7:0] first_byte_reg;
state_t current_state, next_state;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        first_byte_reg <= 8'b0;
    end
    else begin
        current_state <= next_state;
        if (valid_in && (current_state == IDLE))
            first_byte_reg <= data_in;
    end
end

// Next state logic
always @(*) begin
    next_state = current_state;
    case (current_state)
        IDLE: if (valid_in) next_state = HAVE_FIRST_BYTE;
        HAVE_FIRST_BYTE: if (valid_in) next_state = IDLE;
    endcase
end

// Output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end
    else begin
        valid_out <= 1'b0;
        if ((current_state == HAVE_FIRST_BYTE) && valid_in) begin
            data_out <= {first_byte_reg, data_in};
            valid_out <= 1'b1;
        end
    end
end

endmodule