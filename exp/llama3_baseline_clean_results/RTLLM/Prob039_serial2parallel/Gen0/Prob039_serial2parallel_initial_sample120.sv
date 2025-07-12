module serial2parallel(
    input               clk,          // Clock signal
    input               rst_n,        // Reset signal (active low)
    input               din_serial,   // Serial input data
    input               din_valid,    // Validity signal for input data
    output reg [7:0]    dout_parallel, // Parallel output data (8 bits wide)
    output reg          dout_valid    // Validity signal for the output data
);

reg [3:0] cnt;  // 4-bit counter

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'b0000;
        dout_valid <= 1'b0;
        dout_parallel <= 8'b00000000;
    end else if (din_valid) begin
        if (cnt == 4'b1000) begin
            cnt <= 4'b0000;
            dout_parallel <= {din_serial, dout_parallel[7:1]};
            dout_valid <= 1'b1;
        end else begin
            cnt <= cnt + 1;
            dout_parallel <= {din_serial, dout_parallel[7:1]};
            dout_valid <= 1'b0;
        end
    end else begin
        cnt <= cnt;
        dout_parallel <= dout_parallel;
        if (dout_valid) begin
            dout_valid <= 1'b0;
        end else begin
            dout_valid <= 1'b0;
        end
    end
end

endmodule