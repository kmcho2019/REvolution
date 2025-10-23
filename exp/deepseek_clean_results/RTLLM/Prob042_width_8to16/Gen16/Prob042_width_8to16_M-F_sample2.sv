module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg has_first;      // Flag indicating we have first byte
reg [7:0] first_byte; // Storage for first byte

always @(posedge clk) begin
    if (!rst_n) begin
        // Synchronous reset
        has_first <= 1'b0;
        first_byte <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // Clear valid_out unless we're generating output
        valid_out <= 1'b0;

        if (valid_in) begin
            if (has_first) begin
                // We have both bytes - generate output
                data_out <= {first_byte, data_in};
                valid_out <= 1'b1;
                has_first <= 1'b0; // Ready for new pair
            end else begin
                // Store first byte
                first_byte <= data_in;
                has_first <= 1'b1;
            end
        end
    end
end

endmodule