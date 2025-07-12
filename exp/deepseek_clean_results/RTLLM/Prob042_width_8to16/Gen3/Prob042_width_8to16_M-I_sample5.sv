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
    GOT_FIRST_BYTE
} state_t;

reg state, next_state;
reg [7:0] first_byte;
reg first_byte_en;  // Clock enable for first_byte

// Synchronous state update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        first_byte <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        state <= next_state;
        
        // Clock-gated register update
        if (first_byte_en) begin
            first_byte <= data_in;
        end
        
        // Output generation
        if (state == GOT_FIRST_BYTE && valid_in) begin
            data_out <= {first_byte, data_in};
            valid_out <= 1'b1;
        end else begin
            valid_out <= 1'b0;
        end
    end
end

// Next state logic
always_comb begin
    next_state = state;
    first_byte_en = 1'b0;
    
    case (state)
        IDLE: begin
            if (valid_in) begin
                next_state = GOT_FIRST_BYTE;
                first_byte_en = 1'b1;
            end
        end
        
        GOT_FIRST_BYTE: begin
            if (valid_in) begin
                next_state = IDLE;
            end
        end
    endcase
end

endmodule