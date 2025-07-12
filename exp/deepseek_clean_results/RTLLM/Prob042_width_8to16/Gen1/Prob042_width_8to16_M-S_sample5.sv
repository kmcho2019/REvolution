module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_lock;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset condition
        data_lock <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // Default assignment
        valid_out <= 1'b0;
        
        if (valid_in) begin
            if (data_lock == 8'b0) begin
                // Store first byte
                data_lock <= data_in;
            end else begin
                // Output concatenated data
                data_out <= {data_lock, data_in};
                valid_out <= 1'b1;
                data_lock <= 8'b0;  // Clear for next pair
            end
        end
    end
end

endmodule