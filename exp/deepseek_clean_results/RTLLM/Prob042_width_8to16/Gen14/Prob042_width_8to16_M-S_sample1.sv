module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg has_first_byte;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        has_first_byte <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= 1'b0;  // Default assignment
        
        if (valid_in) begin
            if (!has_first_byte) begin
                // Store first byte in upper bits
                data_out[15:8] <= data_in;
                has_first_byte <= 1'b1;
            end else begin
                // Concatenate with lower bits and output
                data_out[7:0] <= data_in;
                valid_out <= 1'b1;
                has_first_byte <= 1'b0;
            end
        end
    end
end

endmodule