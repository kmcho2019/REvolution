module serial2parallel(
    input clk,         // Clock signal
    input rst_n,       // Reset signal (active low)
    input din_serial,  // Serial input data
    input din_valid,   // Validity signal for input data
    output reg [7:0] dout_parallel,  // Parallel output data (8 bits wide)
    output reg dout_valid         // Validity signal for the output data
);

reg [3:0] cnt;  // 4-bit counter

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'd0;
        dout_parallel <= 8'd0;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        cnt <= cnt + 1;
        if (cnt == 4'd8) begin
            dout_valid <= 1'b1;
        end else begin
            dout_valid <= 1'b0;
        end
        dout_parallel <= {dout_parallel[6:0], din_serial};
        if (cnt == 4'd8) begin
            cnt <= 4'd0;
        end
    end
end

endmodule