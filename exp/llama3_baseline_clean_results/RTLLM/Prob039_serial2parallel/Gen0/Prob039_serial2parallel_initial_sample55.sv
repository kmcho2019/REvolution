module serial2parallel (
    input             clk,
    input             rst_n,
    input             din_serial,
    input             din_valid,
    output reg [7:0]  dout_parallel,
    output reg        dout_valid
);

reg [3:0] cnt;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt                <= 4'd0;
        dout_parallel      <= 8'd0;
        dout_valid         <= 1'd0;
    end else if (din_valid) begin
        cnt                <= cnt + 1'd1;
        if (cnt == 4'd0) begin
            dout_parallel  <= {din_serial, 7'd0};
        end else if (cnt < 4'd8) begin
            dout_parallel  <= {din_serial, dout_parallel[7:1]};
        end
        if (cnt == 4'd7) begin
            dout_valid     <= 1'd1;
        end else begin
            dout_valid     <= 1'd0;
        end
    end else begin
        cnt                <= cnt;
        dout_parallel      <= dout_parallel;
        if (dout_valid) begin
            dout_valid     <= 1'd0;
        end else begin
            dout_valid     <= dout_valid;
        end
    end
end

endmodule