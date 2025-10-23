module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

    reg [2:0] position;  // position of the '1' bit: 0 to 7

    always @(posedge clk) begin
        if (reset) begin
            position <= 3'd0;
        end else begin
            position <= (position == 3'd7) ? 3'd0 : position + 3'd1;
        end
    end

    always @(*) begin
        out = 8'b0;
        out[position] = 1'b1;
    end

endmodule