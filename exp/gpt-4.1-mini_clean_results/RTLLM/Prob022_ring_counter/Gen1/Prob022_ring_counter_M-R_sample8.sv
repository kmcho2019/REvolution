module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    reg [2:0] state; // 3-bit state to represent position (0 to 7)

    always @(posedge clk) begin
        if (reset)
            state <= 3'd0;
        else
            state <= state + 3'd1;
    end

    always @(*) begin
        out = 8'b00000001 << state; // Set only the bit at position 'state'
    end

endmodule