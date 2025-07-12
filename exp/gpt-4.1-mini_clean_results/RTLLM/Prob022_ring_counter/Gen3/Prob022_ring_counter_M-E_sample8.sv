module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg  [7:0] out
);

    reg [2:0] pos;  // position of the single '1' bit (0 to 7)

    // Sequential logic: update position on rising edge
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pos <= 3'd0;
        end else begin
            pos <= pos + 3'd1;
        end
    end

    // Combinational logic: decode position into one-hot output
    always @(*) begin
        out = 8'b0;
        out[pos] = 1'b1;
    end

endmodule