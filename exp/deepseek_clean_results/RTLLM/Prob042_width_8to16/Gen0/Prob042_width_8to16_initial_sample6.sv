module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_lock;  // Temporary storage for first byte
reg has_data;         // Flag indicating we have stored first byte

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Active-low reset
        data_lock <= 8'b0;
        has_data <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // Clear valid_out each cycle unless we're outputting new data
        valid_out <= 1'b0;
        
        if (valid_in) begin
            if (!has_data) begin
                // First valid input - store it and set flag
                data_lock <= data_in;
                has_data <= 1'b1;
            end else begin
                // Second valid input - concatenate and output
                data_out <= {data_lock, data_in};
                valid_out <= 1'b1;
                has_data <= 1'b0;  // Ready for next pair
            end
        end
    end
end

endmodule