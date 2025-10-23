module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    parameter MAX_HIGH = 4'd15; // high part of 999 (999 / 64 = 15)
    parameter MAX_LOW  = 6'd39; // low part of 999 (999 % 64 = 39)

    wire [3:0] high_part = q[9:6];
    wire [5:0] low_part  = q[5:0];

    always @(posedge clk) begin
        if (reset) begin
            q <= 10'd0;
        end else begin
            if (high_part == MAX_HIGH && low_part == MAX_LOW)
                q <= 10'd0;
            else
                q <= q + 10'd1;
        end
    end

endmodule