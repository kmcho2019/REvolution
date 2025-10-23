module width_8to16 (
    input            clk,
    input            rst_n,
    input            valid_in,
    input      [7:0] data_in,
    output reg       valid_out,
    output reg [15:0] data_out
);

    reg        first_byte_stored;
    reg [7:0]  data_lock;

    // Registers to hold output data and valid flag for next cycle
    reg        valid_out_next;
    reg [15:0] data_out_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            first_byte_stored <= 1'b0;
            data_lock         <= 8'd0;
            data_out          <= 16'd0;
            valid_out         <= 1'b0;
            valid_out_next    <= 1'b0;
            data_out_next     <= 16'd0;
        end else begin
            // Update outputs to next cycle values
            valid_out <= valid_out_next;
            data_out  <= data_out_next;

            if (valid_in) begin
                if (!first_byte_stored) begin
                    // Store first byte and set flag; no output yet
                    data_lock         <= data_in;
                    first_byte_stored <= 1'b1;

                    // Do not change output registers; hold previous next values
                    // valid_out_next, data_out_next remain unchanged to hold last output
                end else begin
                    // Second byte received, concatenate with stored first byte
                    data_out_next  <= {data_lock, data_in};
                    valid_out_next <= 1'b1;
                    first_byte_stored <= 1'b0;
                end
            end
            // If no valid_in, do not modify valid_out_next or data_out_next,
            // so that output signals hold their last valid state or remain zero after reset
        end
    end

endmodule