module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output wire dout_valid
);

    reg [2:0] cnt;  // 3-bit counter (0-7)
    wire cnt_terminal = (cnt == 3'd7);

    // dout_valid is now combinational
    assign dout_valid = din_valid & cnt_terminal;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'b0;
            dout_parallel <= 8'b0;
        end
        else if (din_valid) begin
            dout_parallel <= {dout_parallel[6:0], din_serial};
            cnt <= cnt_terminal ? 3'b0 : cnt + 1'b1;
        end
    end

endmodule