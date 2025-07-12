module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

    reg [2:0] position;  // position of the '1' bit: 0 to 7

    always @(posedge clk) begin
        if (reset) begin
            position <= 3'd0;
            out <= 8'b0000_0001;
        end else begin
            if (position == 3'd7)
                position <= 3'd0;
            else
                position <= position + 3'd1;
            out <= 8'b1 << position;
        end
    end

endmodule