module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    wire enable_bit1 = q[0];
    wire enable_bit2 = q[0] & q[1];
    wire enable_bit3 = q[0] & q[1] & q[2];

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0000;
        end else begin
            q[0] <= ~q[0];                   // LSB toggles every cycle
            q[1] <= (enable_bit1) ? ~q[1] : q[1];
            q[2] <= (enable_bit2) ? ~q[2] : q[2];
            q[3] <= (enable_bit3) ? ~q[3] : q[3];
        end
    end

endmodule