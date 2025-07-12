module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt; // 4-bit counter

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers on active-low reset
        cnt <= 4'b0;
        dout_parallel <= 8'b0;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        // Shift serial input into parallel output on valid input data
        if (cnt < 4'd8) begin
            dout_parallel <= {dout_parallel[6:0], din_serial};
            cnt <= cnt + 1'b1;
        end
        // Set valid output signal after 8 serial data bits have been received
        if (cnt == 4'd7) begin
            dout_valid <= 1'b1;
        end else begin
            dout_valid <= 1'b0;
        end
    end
end

endmodule