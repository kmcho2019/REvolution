module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'd0;
        dout_parallel <= 8'd0;
        dout_valid <= 1'd0;
    end else if (din_valid) begin
        if (cnt == 4'd7) begin
            cnt <= 4'd0;
            dout_valid <= 1'd1;
        end else begin
            cnt <= cnt + 1'd1;
            dout_valid <= 1'd0;
        end
        case (cnt)
            4'd0: dout_parallel <= {din_serial, 7'd0};
            4'd1: dout_parallel <= {dout_parallel[6:0], din_serial};
            4'd2: dout_parallel <= {dout_parallel[6:1], din_serial, dout_parallel[0]};
            4'd3: dout_parallel <= {dout_parallel[6:2], din_serial, dout_parallel[1:0]};
            4'd4: dout_parallel <= {dout_parallel[6:3], din_serial, dout_parallel[2:0]};
            4'd5: dout_parallel <= {dout_parallel[6:4], din_serial, dout_parallel[3:0]};
            4'd6: dout_parallel <= {dout_parallel[6:5], din_serial, dout_parallel[4:0]};
            4'd7: dout_parallel <= {dout_parallel[6:6], din_serial, dout_parallel[5:0]};
        endcase
    end else begin
        cnt <= cnt;
        dout_parallel <= dout_parallel;
        if (cnt == 4'd7)
            dout_valid <= 1'd1;
        else
            dout_valid <= 1'd0;
    end
end

endmodule