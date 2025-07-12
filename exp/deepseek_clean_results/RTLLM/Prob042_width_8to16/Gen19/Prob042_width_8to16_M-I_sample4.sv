module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// Internal registers
reg has_first_byte;
reg [7:0] first_byte_reg;

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        has_first_byte <= 1'b0;
        first_byte_reg <= 8'b0;
        data_out <= 16'b0;
        valid_out <= 1'b0;
    end else begin
        // Default outputs
        valid_out <= 1'b0;
        
        // Handle valid input
        if (valid_in) begin
            if (!has_first_byte) begin
                // Store first byte and set flag
                first_byte_reg <= data_in;
                has_first_byte <= 1'b1;
            end else begin
                // Combine with stored byte and output
                data_out <= {first_byte_reg, data_in};
                valid_out <= 1'b1;
                has_first_byte <= 1'b0;
            end
        end
    end
end

endmodule