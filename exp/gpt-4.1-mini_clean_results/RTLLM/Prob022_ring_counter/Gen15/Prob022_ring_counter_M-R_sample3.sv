module ring_counter (
    input clk,
    input reset,
    output [7:0] out
);

    reg [2:0] pos; // position of the '1' bit: 0..7

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pos <= 3'd0;
        end else begin
            pos <= (pos == 3'd7) ? 3'd0 : pos + 3'd1;
        end
    end

    // Continuous assignment for output using left shift
    assign out = 8'b1 << pos;

endmodule