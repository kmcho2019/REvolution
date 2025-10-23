module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg start_bit_detected;
reg [7:0] data;
reg stop_bit_verified;

always @(posedge clk) begin
    if (reset) begin
        start_bit_detected <= 1'b0;
        data <= 8'b0;
        stop_bit_verified <= 1'b0;
        done <= 1'b0;
    end else begin
        // Stage 1: Start bit detection
        if (~in) begin
            start_bit_detected <= 1'b1;
        end else begin
            start_bit_detected <= 1'b0;
        end

        // Stage 2: Data bit collection
        if (start_bit_detected) begin
            data <= {data[6:0], in};
        end

        // Stage 3: Stop bit verification
        if (data[7]) begin
            stop_bit_verified <= 1'b1;
        end else begin
            stop_bit_verified <= 1'b0;
        end

        // Generate 'done' signal
        if (stop_bit_verified) begin
            done <= 1'b1;
        end else begin
            done <= 1'b0;
        end
    end
end

endmodule