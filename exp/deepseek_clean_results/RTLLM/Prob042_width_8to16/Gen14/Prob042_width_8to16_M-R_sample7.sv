module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output wire [15:0] data_out
);

// State encoding
typedef enum logic [1:0] {
    IDLE,
    GOT_FIRST
} state_t;

reg [1:0] state;
reg [7:0] first_byte;
reg [15:0] data_out_reg;

// Continuous assignment for data output
assign data_out = data_out_reg;

always @(posedge clk) begin
    if (!rst_n) begin
        state <= IDLE;
        first_byte <= 8'b0;
        data_out_reg <= 16'b0;
        valid_out <= 1'b0;
    end else begin
        valid_out <= 1'b0;  // Default to not valid
        
        case (state)
            IDLE: begin
                if (valid_in) begin
                    first_byte <= data_in;
                    state <= GOT_FIRST;
                end
            end
            
            GOT_FIRST: begin
                if (valid_in) begin
                    data_out_reg <= {first_byte, data_in};
                    valid_out <= 1'b1;
                    state <= IDLE;
                end
            end
            
            default: state <= IDLE;
        endcase
    end
end

endmodule