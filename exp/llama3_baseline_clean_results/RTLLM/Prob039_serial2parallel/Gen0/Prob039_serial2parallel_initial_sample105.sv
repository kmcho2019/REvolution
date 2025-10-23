module serial2parallel(
    input             clk,
    input             rst_n,
    input             din_serial,
    input             din_valid,
    output reg [7:0]  dout_parallel,
    output reg        dout_valid
);

reg [3:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt                <= 4'b0000;
        dout_parallel      <= 8'b00000000;
        dout_valid         <= 1'b0;
    end else if (din_valid) begin
        if (cnt == 4'b1000) begin
            cnt            <= 4'b0000;
            dout_valid     <= 1'b1;
        end else begin
            cnt            <= cnt + 1'b1;
            dout_valid     <= 1'b0;
        end
        case (cnt)
            4'b0000: dout_parallel <= {din_serial, 7'b0000000};
            4'b0001: dout_parallel <= {dout_parallel[6:0], din_serial};
            4'b0010: dout_parallel <= {dout_parallel[5:0], din_serial, 2'b00};
            4'b0011: dout_parallel <= {dout_parallel[4:0], din_serial, 3'b000};
            4'b0100: dout_parallel <= {dout_parallel[3:0], din_serial, 4'b0000};
            4'b0101: dout_parallel <= {dout_parallel[2:0], din_serial, 5'b00000};
            4'b0110: dout_parallel <= {dout_parallel[1:0], din_serial, 6'b000000};
            4'b0111: dout_parallel <= {din_serial, 7'b0000000};
            default: dout_parallel <= dout_parallel;
        endcase
    end else begin
        cnt            <= cnt;
        dout_parallel <= dout_parallel;
        dout_valid     <= dout_valid;
    end
end

endmodule