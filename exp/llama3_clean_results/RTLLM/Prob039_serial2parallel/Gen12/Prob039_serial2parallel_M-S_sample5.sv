module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt; // 4-bit counter to keep track of the number of serial input data bits received

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'b0000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        if (cnt < 4'b1000) begin
            // Shift in the new data
            dout_parallel <= {dout_parallel[6:0], din_serial};
            cnt <= cnt + 1'b1;
        end else begin
            cnt <= 4'b0000;
        end
        // Set dout_valid to 1 only after 8 bits have been received
        dout_valid <= (cnt == 4'b1000 - 1'b1);
    end else begin
        // If din_valid is 0, do not update cnt or dout_parallel
        cnt <= cnt;
        dout_parallel <= dout_parallel;
        // Set dout_valid to 0
        dout_valid <= 1'b0;
    end
end

endmodule