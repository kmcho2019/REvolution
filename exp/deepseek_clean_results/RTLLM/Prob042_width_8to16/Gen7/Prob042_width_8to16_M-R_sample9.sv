module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg has_first_byte;
reg [7:0] first_byte;

// Combinational output for valid_out
assign valid_out = has_first_byte & valid_in;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        has_first_byte <= 1'b0;
        first_byte <= 8'b0;
        data_out <= 16'b0;
    end else begin
        if (valid_in) begin
            if (has_first_byte) begin
                // Second byte received - form output
                data_out <= {first_byte, data_in};
                has_first_byte <= 1'b0;  // Ready for new pair
            end else begin
                // First byte received - store it
                first_byte <= data_in;
                has_first_byte <= 1'b1;
            end
        end
    end
end

endmodule