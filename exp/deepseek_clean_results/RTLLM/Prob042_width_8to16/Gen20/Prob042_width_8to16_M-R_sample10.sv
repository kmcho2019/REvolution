module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] first_byte_reg;
reg state; // 0: IDLE, 1: HAVE_FIRST_BYTE

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 1'b0;
        first_byte_reg <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // Default outputs
        valid_out <= 1'b0;
        
        case (state)
            1'b0: begin // IDLE state
                if (valid_in) begin
                    first_byte_reg <= data_in;
                    state <= 1'b1;
                end
            end
            
            1'b1: begin // HAVE_FIRST_BYTE state
                if (valid_in) begin
                    data_out <= {first_byte_reg, data_in};
                    valid_out <= 1'b1;
                    state <= 1'b0;
                end
            end
        endcase
    end
end

endmodule