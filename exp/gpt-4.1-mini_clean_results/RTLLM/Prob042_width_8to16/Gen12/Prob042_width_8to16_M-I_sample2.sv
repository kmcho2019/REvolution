module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg         flag_first;      // Indicates if first byte is stored
    reg  [7:0]  first_byte;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            flag_first  <= 1'b0;
            first_byte  <= 8'd0;
            valid_out   <= 1'b0;
            data_out    <= 16'd0;
        end else begin
            if (valid_in) begin
                if (!flag_first) begin
                    // Store first byte and set flag; no output yet
                    first_byte <= data_in;
                    flag_first <= 1'b1;
                    valid_out  <= 1'b0;
                    data_out   <= 16'd0;
                end else begin
                    // Second byte: concatenate and output
                    data_out   <= {first_byte, data_in};
                    valid_out  <= 1'b1;
                    flag_first <= 1'b0;
                end
            end else begin
                // No valid input: clear outputs, keep flag and first_byte unchanged
                valid_out <= 1'b0;
                data_out  <= 16'd0;
            end
        end
    end

endmodule