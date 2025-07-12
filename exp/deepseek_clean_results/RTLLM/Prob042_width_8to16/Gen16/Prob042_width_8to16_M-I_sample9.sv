module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg has_first_byte;
reg [7:0] first_byte;
reg next_valid;
reg [15:0] next_data;

always @(posedge clk) begin
    if (!rst_n) begin
        // Synchronous reset
        has_first_byte <= 1'b0;
        first_byte <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
        next_valid <= 1'b0;
        next_data <= 16'b0;
    end else begin
        // Default assignments
        valid_out <= next_valid;
        data_out <= next_data;
        next_valid <= 1'b0;
        
        if (valid_in) begin
            if (!has_first_byte) begin
                // Store first byte
                first_byte <= data_in;
                has_first_byte <= 1'b1;
            end else begin
                // Combine with second byte and prepare output
                next_data <= {first_byte, data_in};
                next_valid <= 1'b1;
                has_first_byte <= 1'b0;
            end
        end
    end
end

endmodule