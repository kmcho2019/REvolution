module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// Internal state and storage
reg [7:0] data_lock;
reg has_first_byte; // Flag indicating we have the first byte stored

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        has_first_byte <= 1'b0;
        data_lock <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // Default outputs
        valid_out <= 1'b0;
        
        if (valid_in) begin
            if (!has_first_byte) begin
                // Store first byte and set flag
                data_lock <= data_in;
                has_first_byte <= 1'b1;
            end else begin
                // Concatenate with second byte and output
                data_out <= {data_lock, data_in};
                valid_out <= 1'b1;
                has_first_byte <= 1'b0; // Ready for next pair
            end
        end
    end
end

endmodule