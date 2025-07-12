module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

reg [7:0] first_byte;
reg       first_byte_stored;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        first_byte        <= 8'd0;
        first_byte_stored <= 1'b0;
        data_out          <= 16'd0;
        valid_out         <= 1'b0;
    end else begin
        valid_out <= 1'b0;  // Default no output unless we have two bytes

        if (valid_in) begin
            if (!first_byte_stored) begin
                // Store first byte, wait for second
                first_byte        <= data_in;
                first_byte_stored <= 1'b1;
            end else begin
                // Have first byte, second byte arrives
                data_out          <= {first_byte, data_in};
                valid_out         <= 1'b1;
                first_byte_stored <= 1'b0;
            end
        end
    end
end

endmodule