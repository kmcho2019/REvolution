module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// State encoding
localparam IDLE      = 1'b0;
localparam FIRST_BYTE = 1'b1;

reg state;
reg [7:0] first_byte;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        state <= IDLE;
        first_byte <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // Default outputs
        valid_out <= 1'b0;
        
        // State machine
        case (state)
            IDLE: begin
                if (valid_in) begin
                    // Store first byte and transition state
                    first_byte <= data_in;
                    state <= FIRST_BYTE;
                end
            end
            
            FIRST_BYTE: begin
                if (valid_in) begin
                    // Concatenate and output
                    data_out <= {first_byte, data_in};
                    valid_out <= 1'b1;
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule