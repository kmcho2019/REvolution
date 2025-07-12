module serial2parallel (
    input            clk,
    input            rst_n,
    input            din_serial,
    input            din_valid,
    output reg [7:0]  dout_parallel,
    output reg        dout_valid
);

reg [3:0] cnt; // 4-bit counter

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all signals
        cnt <= 4'd0;
        dout_parallel <= 8'd0;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        // If the input is valid, shift the input data into the output register
        if (cnt == 4'd0) begin
            // First bit, clear the output register and set the MSB
            dout_parallel <= {din_serial, 7'd0};
        end else begin
            // Other bits, shift the output register and set the new bit
            dout_parallel <= {dout_parallel[6:0], din_serial};
        end
        
        // Increment the counter
        if (cnt == 4'd7) begin
            // If the counter reaches 8, set the valid output signal and reset the counter
            cnt <= 4'd0;
            dout_valid <= 1'b1;
        end else begin
            cnt <= cnt + 4'd1;
            dout_valid <= 1'b0; // Reset the valid signal when the counter is not at 8
        end
    end else begin
        // If the input is not valid, do not change the output register or the counter
        cnt <= cnt;
        dout_parallel <= dout_parallel;
        dout_valid <= 1'b0; // Reset the valid signal when there's no valid input
    end
end

endmodule