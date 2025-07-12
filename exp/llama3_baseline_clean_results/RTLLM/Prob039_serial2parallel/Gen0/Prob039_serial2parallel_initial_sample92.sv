module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [2:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 3'b000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        if (cnt == 3'b111) begin
            cnt <= 3'b000;
            dout_valid <= 1'b1;
        end else begin
            cnt <= cnt + 1'b1;
            dout_valid <= 1'b0;
        end
        case (cnt)
            3'b000: dout_parallel <= {din_serial, 7'b0000000};
            3'b001: dout_parallel <= {dout_parallel[7:1], din_serial};
            3'b010: dout_parallel <= {dout_parallel[7:1], din_serial};
            3'b011: dout_parallel <= {dout_parallel[7:1], din_serial};
            3'b100: dout_parallel <= {dout_parallel[7:1], din_serial};
            3'b101: dout_parallel <= {dout_parallel[7:1], din_serial};
            3'b110: dout_parallel <= {dout_parallel[7:1], din_serial};
            3'b111: dout_parallel <= {dout_parallel[7:1], din_serial};
        endcase
    end else begin
        cnt <= cnt;
        dout_parallel <= dout_parallel;
        dout_valid <= 1'b0;
    end
end

endmodule