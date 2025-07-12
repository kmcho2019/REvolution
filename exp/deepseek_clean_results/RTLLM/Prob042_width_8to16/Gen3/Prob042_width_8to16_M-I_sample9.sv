module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg [8:0] stored_data; // [8] is valid bit, [7:0] is data

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stored_data <= 9'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // Clear valid_out unless we're generating new output
        valid_out <= 1'b0;

        if (valid_in) begin
            if (!stored_data[8]) begin
                // Store first byte with valid bit
                stored_data <= {1'b1, data_in};
            end else begin
                // Combine with second byte and output
                data_out <= {stored_data[7:0], data_in};
                valid_out <= 1'b1;
                stored_data <= 9'b0; // Clear stored data
            end
        end
    end
end

endmodule