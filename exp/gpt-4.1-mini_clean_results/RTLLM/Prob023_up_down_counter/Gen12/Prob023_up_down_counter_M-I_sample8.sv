module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [15:0] count
);

always @(posedge clk) begin
    if (reset)
        count <= 16'd0;
    else
        // count + 1 when up_down=1; count - 1 when up_down=0
        count <= count + (up_down ? 16'd1 : 16'd65535); // 65535 == -1 in 16-bit two's complement
end

endmodule