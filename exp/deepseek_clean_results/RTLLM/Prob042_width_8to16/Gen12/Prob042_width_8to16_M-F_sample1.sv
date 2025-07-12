module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// Internal registers
reg [7:0] data_buffer;  // Stores first byte
reg buffer_valid;       // Indicates first byte is stored

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        data_buffer <= 8'b0;
        buffer_valid <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // Default outputs
        valid_out <= 1'b0;
        
        if (valid_in) begin
            if (!buffer_valid) begin
                // First byte - store in buffer
                data_buffer <= data_in;
                buffer_valid <= 1'b1;
            end else begin
                // Second byte - concatenate and output
                data_out <= {data_buffer, data_in};
                valid_out <= 1'b1;
                buffer_valid <= 1'b0;  // Ready for next pair
            end
        end
    end
end

endmodule