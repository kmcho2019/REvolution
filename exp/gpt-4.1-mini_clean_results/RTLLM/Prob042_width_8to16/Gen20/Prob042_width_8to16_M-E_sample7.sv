module width_8to16 (
    input             clk,
    input             rst_n,
    input             valid_in,
    input      [7:0]  data_in,
    output reg        valid_out,
    output reg [15:0] data_out
);

    reg [7:0]  first_byte;
    reg        has_first;

    reg [15:0] out_data_stage;
    reg        out_valid_stage;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            first_byte     <= 8'd0;
            has_first      <= 1'b0;
            out_data_stage <= 16'd0;
            out_valid_stage<= 1'b0;
            data_out       <= 16'd0;
            valid_out      <= 1'b0;
        end else begin
            // Default output stage transfer
            data_out  <= out_data_stage;
            valid_out <= out_valid_stage;

            // Default clear output stage valid flag
            out_valid_stage <= 1'b0;

            if (valid_in) begin
                if (!has_first) begin
                    // Capture first byte, wait for next byte
                    first_byte <= data_in;
                    has_first  <= 1'b1;
                end else begin
                    // On second byte, concatenate and prepare output next cycle
                    out_data_stage  <= {first_byte, data_in};
                    out_valid_stage <= 1'b1;
                    has_first       <= 1'b0;
                end
            end
        end
    end

endmodule