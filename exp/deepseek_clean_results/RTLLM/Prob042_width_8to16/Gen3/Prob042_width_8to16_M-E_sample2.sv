module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg [15:0] shift_reg;
reg [1:0] byte_count; // Counts 0, 1, or 2 bytes received

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 16'b0;
        byte_count <= 2'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= 1'b0; // Default no valid output
        
        if (valid_in) begin
            // Shift existing data left and insert new byte at LSB
            shift_reg <= {shift_reg[7:0], data_in};
            
            if (byte_count == 2'b01) begin
                // Second byte received - output the result
                data_out <= {shift_reg[7:0], data_in};
                valid_out <= 1'b1;
                byte_count <= 2'b0;
            end else begin
                // First byte received or counter overflow (shouldn't happen)
                byte_count <= byte_count + 1'b1;
            end
        end
    end
end

endmodule