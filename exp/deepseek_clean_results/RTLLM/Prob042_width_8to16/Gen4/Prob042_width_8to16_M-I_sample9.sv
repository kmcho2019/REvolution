module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] saved_byte;
reg has_first_byte;
reg [15:0] next_data_out;
reg next_valid_out;

always @(posedge clk) begin
    if (!rst_n) begin
        saved_byte <= 8'b0;
        has_first_byte <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
        next_valid_out <= 1'b0;
        next_data_out <= 16'b0;
    end else begin
        // Update outputs from previous cycle
        valid_out <= next_valid_out;
        data_out <= next_data_out;
        
        // Default values for next cycle
        next_valid_out <= 1'b0;
        next_data_out <= 16'b0;
        
        if (valid_in) begin
            if (!has_first_byte) begin
                // Store first byte
                saved_byte <= data_in;
                has_first_byte <= 1'b1;
            end else begin
                // Prepare output for next cycle
                next_data_out <= {saved_byte, data_in};
                next_valid_out <= 1'b1;
                has_first_byte <= 1'b0;
            end
        end
    end
end

endmodule