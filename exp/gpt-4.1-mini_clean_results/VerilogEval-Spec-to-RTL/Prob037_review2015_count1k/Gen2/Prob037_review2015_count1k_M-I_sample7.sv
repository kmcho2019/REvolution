module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    wire terminal_count;

    // 999 decimal = 0x3E7 = binary 0011_1110_0111
    // q[9:4] == 15 (0xF), q[3:0] == 7 (0x7)
    assign terminal_count = (q[9:4] == 6'd15) && (q[3:0] == 4'd7);

    always @(posedge clk) begin
        if (reset)
            q <= 10'd0;
        else if (terminal_count)
            q <= 10'd0;
        else
            q <= q + 10'd1;
    end

endmodule