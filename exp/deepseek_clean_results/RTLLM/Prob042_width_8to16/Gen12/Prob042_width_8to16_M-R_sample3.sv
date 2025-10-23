module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output wire valid_out,
    output wire [15:0] data_out
);

// State definitions
typedef enum logic {
    IDLE,
    HAS_FIRST_BYTE
} state_t;

// State and data registers
state_t state, next_state;
reg [7:0] first_byte_reg;
reg [15:0] data_out_reg;
reg valid_out_reg;

// Continuous assignments for outputs
assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

// State transition logic
always @(*) begin
    next_state = state;
    case (state)
        IDLE: if (valid_in) next_state = HAS_FIRST_BYTE;
        HAS_FIRST_BYTE: if (valid_in) next_state = IDLE;
    endcase
end

// Data path and output generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        first_byte_reg <= 8'b0;
        data_out_reg <= 16'b0;
        valid_out_reg <= 1'b0;
    end else begin
        state <= next_state;
        valid_out_reg <= 1'b0;  // Default
        
        if (valid_in) begin
            case (state)
                IDLE: begin
                    first_byte_reg <= data_in;
                end
                HAS_FIRST_BYTE: begin
                    data_out_reg <= {first_byte_reg, data_in};
                    valid_out_reg <= 1'b1;
                end
            endcase
        end
    end
end

endmodule