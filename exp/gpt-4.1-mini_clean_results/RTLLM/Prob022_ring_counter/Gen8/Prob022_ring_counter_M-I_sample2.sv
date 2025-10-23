module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

    reg [2:0] position;  // position of the '1' bit: 0 to 7

    // Sequential logic: update position counter on clock edge
    always @(posedge clk) begin
        if (reset) begin
            position <= 3'd0;
        end else begin
            position <= (position == 3'd7) ? 3'd0 : position + 3'd1;
        end
    end

    // Combinational logic: generate one-hot output by shifting 1 by position bits
    always @(*) begin
        out = 8'b1 << position;
    end

endmodule