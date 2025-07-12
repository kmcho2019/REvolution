module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [2:0] cnt; // 3-bit counter to keep track of the number of serial input data bits received

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        // Shift in the new data and increment counter
        dout_parallel <= {dout_parallel[6:0], din_serial};
        if (cnt < 3'b111) begin
            cnt <= cnt + 1'b1;
            dout_valid <= 1'b0;
        end else begin
            cnt <= 3'b000;
            dout_valid <= 1'b1;
        end
    end else begin
        // No action on invalid input
        if (cnt == 3'b111) begin
            // Keep dout_valid high if we've just finished receiving 8 bits
            dout_valid <= 1'b1;
        end else begin
            dout_valid <= 1'b0;
        end
    end
end

endmodule