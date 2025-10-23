module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

    reg [2:0] position;

    always @(posedge clk or posedge reset) begin
        if (reset)
            position <= 3'd0;
        else
            position <= (position == 3'd7) ? 3'd0 : position + 3'd1;
    end

    always @(*) begin
        out = 8'b1 << position;
    end

endmodule