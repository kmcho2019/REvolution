module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg has_first_data;  // State: 0=waiting for first data, 1=waiting for second data
reg [7:0] first_data;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        has_first_data <= 1'b0;
        first_data <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= 1'b0;  // Default to not valid
        
        if (valid_in) begin
            if (!has_first_data) begin
                // Store first data and wait for second
                first_data <= data_in;
                has_first_data <= 1'b1;
            end else begin
                // Combine with second data and output
                data_out <= {first_data, data_in};
                valid_out <= 1'b1;
                has_first_data <= 1'b0;
            end
        end
    end
end

endmodule