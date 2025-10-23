module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0]  stored_byte;
    reg        have_first_byte;

    // Registers to hold next cycle outputs
    reg        valid_out_next;
    reg [15:0] data_out_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stored_byte     <= 8'd0;
            have_first_byte <= 1'b0;
            valid_out       <= 1'b0;
            data_out        <= 16'd0;
            valid_out_next  <= 1'b0;
            data_out_next   <= 16'd0;
        end else begin
            // Update output registers
            valid_out <= valid_out_next;
            data_out  <= data_out_next;

            // Default next cycle outputs
            valid_out_next <= 1'b0;

            if (valid_in) begin
                if (!have_first_byte) begin
                    // Store first byte and set flag
                    stored_byte     <= data_in;
                    have_first_byte <= 1'b1;
                end else begin
                    // Second byte: prepare concatenated output for next cycle
                    data_out_next   <= {stored_byte, data_in};
                    valid_out_next  <= 1'b1;
                    have_first_byte <= 1'b0;
                end
            end
        end
    end

endmodule