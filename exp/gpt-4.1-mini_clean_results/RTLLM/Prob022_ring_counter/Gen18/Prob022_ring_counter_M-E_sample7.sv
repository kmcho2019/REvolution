module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    reg [2:0] position; // 3 bits to index 0-7

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            position <= 3'd0;
        end else begin
            if (position == 3'd7)
                position <= 3'd0;
            else
                position <= position + 3'd1;
        end
    end

    always @(*) begin
        out = 8'b1 << position;
    end

endmodule