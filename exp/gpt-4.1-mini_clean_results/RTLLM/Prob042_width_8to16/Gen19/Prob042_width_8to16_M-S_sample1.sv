module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0]  data_lock;      // stores first 8-bit data
    reg        has_data_lock;  // flag indicating stored first byte

    reg        valid_out_d;    // delayed valid_out
    reg [15:0] data_out_d;     // delayed data_out

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock     <= 8'd0;
            has_data_lock <= 1'b0;
            valid_out_d   <= 1'b0;
            data_out_d    <= 16'd0;
            valid_out     <= 1'b0;
            data_out      <= 16'd0;
        end else begin
            // Default output valid low; will be updated below if needed
            valid_out <= valid_out_d;
            data_out  <= data_out_d;

            if (valid_in) begin
                if (!has_data_lock) begin
                    // Store first byte
                    data_lock     <= data_in;
                    has_data_lock <= 1'b1;
                    valid_out_d   <= 1'b0; // no output yet
                end else begin
                    // Second byte: form output and clear flag
                    data_out_d    <= {data_lock, data_in};
                    valid_out_d   <= 1'b1;
                    has_data_lock <= 1'b0;
                end
            end else begin
                // When no valid input, no new output; keep valid_out_d low
                valid_out_d <= 1'b0;
            end
        end
    end

endmodule