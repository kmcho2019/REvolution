module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg start_bit_detected;
reg [7:0] data_bits;
reg stop_bit_verified;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        start_bit_detected <= 1'b0;
        data_bits <= 8'b0;
        stop_bit_verified <= 1'b0;
        done_reg <= 1'b0;
    end else begin
        // Start Bit Detection stage
        if (~in) begin
            start_bit_detected <= 1'b1;
        end else if (start_bit_detected) begin
            start_bit_detected <= 1'b0;
        end

        // Data Bit Collection stage
        if (start_bit_detected) begin
            data_bits <= {data_bits[6:0], in};
        end

        // Stop Bit Verification stage
        if (start_bit_detected && data_bits == 8'b1) begin
            if (in) begin
                stop_bit_verified <= 1'b1;
            end else begin
                stop_bit_verified <= 1'b0;
            end
        end else if (stop_bit_verified) begin
            stop_bit_verified <= 1'b0;
        end

        // Done Signal Generation stage
        if (stop_bit_verified) begin
            done_reg <= 1'b1;
        end else if (done_reg) begin
            done_reg <= 1'b0;
        end
    end
end

assign done = done_reg;

endmodule