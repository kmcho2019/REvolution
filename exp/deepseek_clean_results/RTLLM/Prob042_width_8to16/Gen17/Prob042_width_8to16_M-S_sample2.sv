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

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        first_byte <= 8'b0;
        has_first_byte <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= 1'b0;  // Default output
        
        if (valid_in) begin
            if (has_first_byte) begin
                // Second byte arrived - output concatenated data
                data_out <= {first_byte, data_in};
                valid_out <= 1'b1;
                has_first_byte <= 1'b0;
            end else begin
                // First byte - store it
                first_byte <= data_in;
                has_first_byte <= 1'b1;
            end
        end
    end
end

endmodule