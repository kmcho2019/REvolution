module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] first_byte;
reg has_first_byte;

always @(posedge clk) begin
    if (!rst_n) begin
        first_byte <= 8'b0;
        has_first_byte <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= 1'b0; // Default assignment
        
        if (valid_in) begin
            if (!has_first_byte) begin
                // Store first byte
                first_byte <= data_in;
                has_first_byte <= 1'b1;
            end else begin
                // Combine with second byte and output
                data_out <= {first_byte, data_in};
                valid_out <= 1'b1;
                // Store current byte as first byte if we have back-to-back valids
                first_byte <= data_in;
                has_first_byte <= 1'b1;
            end
        end
    end
end

endmodule