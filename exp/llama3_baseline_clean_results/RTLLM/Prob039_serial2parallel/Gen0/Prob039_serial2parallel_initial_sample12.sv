module serial2parallel(
    input             clk,
    input             rst_n,
    input             din_serial,
    input             din_valid,
    output reg [7:0]  dout_parallel,
    output reg         dout_valid
);

reg [2:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        dout_parallel <= 8'b0;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        if (cnt < 3'b111) begin
            // shift the bits of the register to make room for the new serial input data
            dout_parallel <= {dout_parallel[6:0], din_serial};
            cnt <= cnt + 1'b1;
        end else begin
            // reset the counter and set dout_valid to 1
            cnt <= 3'b000;
            dout_valid <= 1'b1;
        end
    end else begin
        // if din_valid is 0, do not update dout_parallel and cnt
        cnt <= cnt;
        dout_parallel <= dout_parallel;
    end
end

// reset dout_valid on the next clock cycle
always @(posedge clk) begin
    if (dout_valid) begin
        dout_valid <= 1'b0;
    end
end

endmodule