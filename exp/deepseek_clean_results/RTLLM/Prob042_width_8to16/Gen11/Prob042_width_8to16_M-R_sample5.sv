module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output wire valid_out,
    output wire [15:0] data_out
);

reg has_first_byte;
reg [7:0] first_byte_reg;
reg [15:0] output_reg;
reg valid_reg;

// Internal storage and control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        has_first_byte <= 1'b0;
        first_byte_reg <= 8'b0;
        output_reg <= 16'b0;
        valid_reg <= 1'b0;
    end else begin
        // Clear valid one cycle after assertion
        valid_reg <= 1'b0;
        
        if (valid_in) begin
            if (!has_first_byte) begin
                // Store first byte and set flag
                first_byte_reg <= data_in;
                has_first_byte <= 1'b1;
            end else begin
                // Combine with stored byte and clear flag
                output_reg <= {first_byte_reg, data_in};
                valid_reg <= 1'b1;
                has_first_byte <= 1'b0;
            end
        end
    end
end

// Continuous output assignments
assign valid_out = valid_reg;
assign data_out = output_reg;

endmodule