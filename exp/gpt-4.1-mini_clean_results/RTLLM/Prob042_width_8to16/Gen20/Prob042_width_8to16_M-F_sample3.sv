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
            // Update output registers from next cycle registers
            valid_out <= valid_out_next;
            data_out  <= data_out_next;

            if (valid_in) begin
                if (!first_byte_stored) begin
                    // Store first byte; no output yet
                    data_lock         <= data_in;
                    first_byte_stored <= 1'b1;

                    // No output update on this cycle; clear valid_out_next and data_out_next
                    valid_out_next <= 1'b0;
                    data_out_next  <= 16'd0;
                end else begin
                    // Second byte received; concatenate and prepare output for next cycle
                    data_out_next  <= {data_lock, data_in};
                    valid_out_next <= 1'b1;
                    first_byte_stored <= 1'b0;
                end
            end else begin
                // No valid input this cycle; clear valid_out_next and data_out_next
                valid_out_next <= 1'b0;
                data_out_next  <= 16'd0;
            end
        end
    end

endmodule