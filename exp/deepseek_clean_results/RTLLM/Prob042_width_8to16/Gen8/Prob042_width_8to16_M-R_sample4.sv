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

reg [7:0] data_lock;  // Stores first byte
state_t current_state;

// State machine and data processing
always @(posedge clk) begin
    if (!rst_n) begin
        current_state <= IDLE;
        data_lock <= 8'b0;
        data_out <= 16'b0;
    end
    else begin
        case (current_state)
            IDLE: begin
                if (valid_in) begin
                    data_lock <= data_in;
                    current_state <= HAVE_FIRST_BYTE;
                end
            end
            
            HAVE_FIRST_BYTE: begin
                if (valid_in) begin
                    data_out <= {data_lock, data_in};
                    current_state <= IDLE;
                end
            end
        endcase
    end
end

// Valid output generation (one cycle delayed)
always @(posedge clk) begin
    if (!rst_n) begin
        valid_out <= 1'b0;
    end
    else begin
        valid_out <= (current_state == HAVE_FIRST_BYTE) && valid_in;
    end
end

endmodule