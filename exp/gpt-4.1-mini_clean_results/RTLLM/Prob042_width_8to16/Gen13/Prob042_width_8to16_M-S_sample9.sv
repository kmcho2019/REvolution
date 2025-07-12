module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0] stored_byte;
    reg       have_first_byte;
    reg       output_valid_dly;  // delayed valid_out flag
    reg [15:0] data_out_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stored_byte    <= 8'd0;
            have_first_byte <= 1'b0;
            valid_out      <= 1'b0;
            data_out       <= 16'd0;
            output_valid_dly <= 1'b0;
            data_out_next  <= 16'd0;
        end else begin
            valid_out <= output_valid_dly;     // valid_out asserted one cycle after second byte
            data_out  <= data_out_next;

            output_valid_dly <= 1'b0;          // default no output

            if (valid_in) begin
                if (!have_first_byte) begin
                    // Store first byte, no output yet
                    stored_byte <= data_in;
                    have_first_byte <= 1'b1;
                end else begin
                    // Second byte arrived
                    data_out_next <= {stored_byte, data_in};
                    output_valid_dly <= 1'b1;    // assert valid_out next cycle
                    have_first_byte <= 1'b0;    // reset flag
                end
            end
        end
    end

endmodule