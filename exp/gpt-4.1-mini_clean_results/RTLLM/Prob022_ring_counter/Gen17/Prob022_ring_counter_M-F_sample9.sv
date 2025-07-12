module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    reg [2:0] pos; // position of the '1' bit: 0..7
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pos <= 3'd0;
            // set only LSB to 1, others to 0
            for (i = 0; i < 8; i = i + 1)
                out[i] <= (i == 0) ? 1'b1 : 1'b0;
        end else begin
            // update position with wrap-around
            pos <= (pos == 3'd7) ? 3'd0 : pos + 3'd1;
            // set output bits: only the bit at 'pos' is 1, rest 0
            for (i = 0; i < 8; i = i + 1)
                out[i] <= (i == pos) ? 1'b1 : 1'b0;
        end
    end

endmodule