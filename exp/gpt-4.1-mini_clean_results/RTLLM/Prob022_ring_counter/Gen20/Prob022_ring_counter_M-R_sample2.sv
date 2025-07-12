module ring_counter (
    input clk,
    input reset,
    output [7:0] out
);

    reg [2:0] pos; // 3-bit position index from 0 to 7

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pos <= 3'd0;
        end else begin
            if (pos == 3'd7)
                pos <= 3'd0;
            else
                pos <= pos + 3'd1;
        end
    end

    // Combinational one-hot encoding of position
    assign out = 8'b0000_0001 << pos;

endmodule