module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// Explicit state encoding
localparam [1:0] 
    IDLE = 2'b00,
    HAS_FIRST_BYTE = 2'b01;

reg [1:0] state;
reg [7:0] first_byte;

always @(posedge clk) begin
    if (!rst_n) begin
        state <= IDLE;
        first_byte <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        case (state)
            IDLE: begin
                valid_out <= 1'b0;  // Only assign when needed
                if (valid_in) begin
                    first_byte <= data_in;
                    state <= HAS_FIRST_BYTE;
                end
            end
            
            HAS_FIRST_BYTE: begin
                if (valid_in) begin
                    data_out <= {first_byte, data_in};
                    valid_out <= 1'b1;
                    state <= IDLE;
                end else begin
                    valid_out <= 1'b0;  // Explicitly maintain low when no new data
                end
            end
            
            default: state <= IDLE;  // Handle unexpected states
        endcase
    end
end

endmodule