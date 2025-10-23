module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] saved_byte;
reg has_first_byte;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        saved_byte <= 8'b0;
        has_first_byte <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= 1'b0;  // Default no valid output
        
        if (valid_in) begin
            if (!has_first_byte) begin
                // Store first byte
                saved_byte <= data_in;
                has_first_byte <= 1'b1;
            end else begin
                // Combine with second byte and output
                data_out <= {saved_byte, data_in};
                valid_out <= 1'b1;
                has_first_byte <= 1'b0;  // Ready for next pair
            end
        end
    end
end

endmodule