module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] first_byte;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        first_byte <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= 1'b0;  // Default output
        
        if (valid_in) begin
            if (first_byte == 8'b0) begin
                // Store first byte
                first_byte <= data_in;
            end else begin
                // Combine with stored byte and output
                data_out <= {first_byte, data_in};
                valid_out <= 1'b1;
                first_byte <= 8'b0;  // Clear for next pair
            end
        end
    end
end

endmodule