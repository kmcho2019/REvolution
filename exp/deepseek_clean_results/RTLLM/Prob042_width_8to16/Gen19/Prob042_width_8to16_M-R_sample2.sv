module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg has_first_byte;  // State: 0 = waiting for first byte, 1 = waiting for second byte
reg [7:0] first_byte;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        has_first_byte <= 1'b0;
        first_byte <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= 1'b0;  // Default output
        
        if (valid_in) begin
            if (!has_first_byte) begin
                // Store first byte and update state
                first_byte <= data_in;
                has_first_byte <= 1'b1;
            end else begin
                // Combine bytes and output
                data_out <= {first_byte, data_in};
                valid_out <= 1'b1;
                has_first_byte <= 1'b0;  // Reset state
            end
        end
    end
end

endmodule