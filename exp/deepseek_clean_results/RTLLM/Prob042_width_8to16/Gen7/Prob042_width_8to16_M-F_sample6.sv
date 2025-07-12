module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// One-hot state encoding
localparam 
    IDLE        = 2'b01,
    WAIT_SECOND = 2'b10;

reg [1:0] state;
reg [7:0] first_byte;

always @(posedge clk) begin
    if (!rst_n) begin
        state <= IDLE;
        first_byte <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // Default assignments
        valid_out <= 1'b0;
        
        case (state)
            IDLE: begin
                if (valid_in) begin
                    first_byte <= data_in;
                    state <= WAIT_SECOND;
                end
            end
            
            WAIT_SECOND: begin
                if (valid_in) begin
                    data_out <= {first_byte, data_in};
                    valid_out <= 1'b1;
                    state <= IDLE;
                end
            end
            
            default: state <= IDLE;
        endcase
    end
end

endmodule