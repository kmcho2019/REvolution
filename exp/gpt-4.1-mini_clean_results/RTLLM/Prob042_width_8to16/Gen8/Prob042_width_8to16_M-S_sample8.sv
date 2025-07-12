module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0] first_byte;
    reg       has_first_byte;

    // Pipeline registers for output valid and data
    reg       valid_out_next;
    reg [15:0] data_out_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            first_byte     <= 8'd0;
            has_first_byte <= 1'b0;
            valid_out      <= 1'b0;
            data_out       <= 16'd0;
            valid_out_next <= 1'b0;
            data_out_next  <= 16'd0;
        end else begin
            valid_out      <= valid_out_next;
            data_out       <= data_out_next;

            valid_out_next <= 1'b0; // Default: no valid output this cycle

            if (valid_in) begin
                if (!has_first_byte) begin
                    // Store first byte
                    first_byte     <= data_in;
                    has_first_byte <= 1'b1;
                end else begin
                    // Second byte arrives: concatenate and prepare output for next cycle
                    data_out_next  <= {first_byte, data_in};
                    valid_out_next <= 1'b1;
                    has_first_byte <= 1'b0; // Reset to wait for next first byte
                end
            end
        end
    end

endmodule