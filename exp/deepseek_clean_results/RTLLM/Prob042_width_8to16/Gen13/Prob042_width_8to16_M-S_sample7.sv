module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] stored_byte;
reg has_stored_byte;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stored_byte <= 8'b0;
        has_stored_byte <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= 1'b0;  // Default to not valid
        
        if (valid_in) begin
            if (!has_stored_byte) begin
                // Store first byte
                stored_byte <= data_in;
                has_stored_byte <= 1'b1;
            end else begin
                // Concatenate and output
                data_out <= {stored_byte, data_in};
                valid_out <= 1'b1;
                has_stored_byte <= 1'b0;  // Ready for next pair
            end
        end
    end
end

endmodule