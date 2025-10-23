module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0] first_byte;
    reg       first_byte_stored;
    reg       valid_out_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            first_byte       <= 8'd0;
            first_byte_stored<= 1'b0;
            data_out         <= 16'd0;
            valid_out        <= 1'b0;
            valid_out_next   <= 1'b0;
        end else begin
            valid_out <= valid_out_next; // valid_out delayed by one cycle

            if (valid_in) begin
                if (!first_byte_stored) begin
                    // Store first byte and wait for second
                    first_byte        <= data_in;
                    first_byte_stored <= 1'b1;
                    valid_out_next    <= 1'b0;
                end else begin
                    // Second byte arrived, prepare output
                    data_out         <= {first_byte, data_in};
                    first_byte_stored<= 1'b0;
                    valid_out_next   <= 1'b1; // valid output next cycle
                end
            end else begin
                // No input this cycle, no valid output
                valid_out_next <= 1'b0;
            end
        end
    end

endmodule