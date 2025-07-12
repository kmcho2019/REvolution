module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] first_byte;
reg first_byte_valid;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        first_byte <= 8'b0;
        first_byte_valid <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end
    else begin
        // Default outputs
        valid_out <= 1'b0;
        
        // First stage: capture first byte
        if (valid_in && !first_byte_valid) begin
            first_byte <= data_in;
            first_byte_valid <= 1'b1;
        end
        // Second stage: output when both bytes are available
        else if (valid_in && first_byte_valid) begin
            data_out <= {first_byte, data_in};
            valid_out <= 1'b1;
            first_byte_valid <= 1'b0;
        end
    end
end

endmodule