module width_8to16 (
    input            clk,
    input            rst_n,
    input            valid_in,
    input      [7:0] data_in,
    output reg       valid_out,
    output reg [15:0] data_out
);

    // State register indicates if first byte has been captured
    reg has_first_byte;
    reg [7:0] data_lock;

    // Registers to hold concatenated output and output valid flag
    reg [15:0] combined_data;
    reg        out_valid_d;

    // Capture inputs and form combined data
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            has_first_byte <= 1'b0;
            data_lock      <= 8'd0;
            combined_data  <= 16'd0;
            out_valid_d    <= 1'b0;
        end else begin
            out_valid_d <= 1'b0; // default no valid output unless set below

            if (valid_in) begin
                if (!has_first_byte) begin
                    // Store first byte
                    data_lock      <= data_in;
                    has_first_byte <= 1'b1;
                end else begin
                    // Second byte arrived, concatenate and mark valid
                    combined_data  <= {data_lock, data_in};
                    out_valid_d    <= 1'b1;
                    has_first_byte <= 1'b0;
                end
            end
        end
    end

    // Register the output signals one cycle after combined_data is ready
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out  <= 16'd0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= out_valid_d;
            data_out  <= out_valid_d ? combined_data : data_out;
        end
    end

endmodule