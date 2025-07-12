module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else if (din_valid) begin
            dout_parallel <= {dout_parallel[6:0], din_serial};
            dout_valid <= &dout_parallel[6:0];  // Valid when all lower 7 bits are filled
        end
        else begin
            dout_valid <= 1'b0;
        end
    end

endmodule