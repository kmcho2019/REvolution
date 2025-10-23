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

    // Register to hold output data one cycle after second byte arrives
    reg      valid_out_reg;
    reg [15:0] data_out_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            first_byte       <= 8'd0;
            first_byte_stored<= 1'b0;
            data_out_reg     <= 16'd0;
            valid_out_reg    <= 1'b0;
        end else begin
            valid_out_reg <= 1'b0; // Default no valid output each cycle

            if (valid_in) begin
                if (!first_byte_stored) begin
                    // Store first byte and set flag
                    first_byte        <= data_in;
                    first_byte_stored <= 1'b1;
                end else begin
                    // Concatenate stored first byte with current byte
                    data_out_reg      <= {first_byte, data_in};
                    valid_out_reg     <= 1'b1;
                    first_byte_stored <= 1'b0; // Clear flag to accept new pair
                end
            end
        end
    end

    // Output registers to synchronize valid_out and data_out
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out <= 1'b0;
            data_out  <= 16'd0;
        end else begin
            valid_out <= valid_out_reg;
            data_out  <= data_out_reg;
        end
    end

endmodule