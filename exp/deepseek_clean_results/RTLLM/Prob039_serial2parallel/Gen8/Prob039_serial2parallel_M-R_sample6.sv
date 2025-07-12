module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output wire dout_valid
);

    parameter BIT_COUNT = 8;
    reg [2:0] cnt;
    wire cnt_full = (cnt == BIT_COUNT-1);

    // Counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'b0;
        end
        else if (din_valid) begin
            cnt <= cnt_full ? 3'b0 : cnt + 1'b1;
        end
    end

    // Shift register logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'b0;
        end
        else if (din_valid) begin
            dout_parallel <= {dout_parallel[6:0], din_serial};
        end
    end

    // Output valid generation (combinational)
    assign dout_valid = din_valid & cnt_full;

endmodule