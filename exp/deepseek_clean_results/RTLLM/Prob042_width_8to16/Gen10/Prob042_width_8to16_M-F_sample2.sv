module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// State encoding with 2 bits for better synthesis
localparam [1:0] IDLE       = 2'b00;
localparam [1:0] FIRST_BYTE = 2'b01;

reg [1:0] state = IDLE;  // Explicit initialization
reg [7:0] first_byte = 8'b0;

// State machine and data processing
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        first_byte <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        case (state)
            IDLE: begin
                valid_out <= 1'b0;  // Only clear when in IDLE
                if (valid_in) begin
                    first_byte <= data_in;
                    state <= FIRST_BYTE;
                end
            end
            
            FIRST_BYTE: begin
                if (valid_in) begin
                    data_out <= {first_byte, data_in};
                    valid_out <= 1'b1;
                    state <= IDLE;
                end else begin
                    valid_out <= 1'b0;  // Maintain low if no valid input
                end
            end
            
            default: begin
                state <= IDLE;
                valid_out <= 1'b0;
            end
        endcase
    end
end

endmodule