module serial2parallel(
    input               clk,
    input               rst_n,
    input               din_serial,
    input               din_valid,
    output reg [7:0]    dout_parallel,
    output reg          dout_valid
);

reg [3:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'b0000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        if (cnt == 4'b1000) begin
            cnt <= 4'b0000;
            dout_valid <= 1'b1;
        end else begin
            cnt <= cnt + 1'b1;
            dout_valid <= 1'b0;
        end
    end
end

always @(posedge clk) begin
    if (din_valid) begin
        case (cnt)
            4'b0000: dout_parallel[7] <= din_serial;
            4'b0001: dout_parallel[6] <= din_serial;
            4'b0010: dout_parallel[5] <= din_serial;
            4'b0011: dout_parallel[4] <= din_serial;
            4'b0100: dout_parallel[3] <= din_serial;
            4'b0101: dout_parallel[2] <= din_serial;
            4'b0110: dout_parallel[1] <= din_serial;
            4'b0111: dout_parallel[0] <= din_serial;
            default: ;
        endcase
    end
end

endmodule