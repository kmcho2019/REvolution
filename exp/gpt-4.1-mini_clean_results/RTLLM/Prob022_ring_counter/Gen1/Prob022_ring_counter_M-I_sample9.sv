module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

    reg [2:0] position;  // 3-bit counter for position 0..7

    always @(posedge clk) begin
        if (reset) begin
            position <= 3'd0;
            out <= 8'b0000_0001;
        end else begin
            // Update position cyclically from 0 to 7
            position <= (position == 3'd7) ? 3'd0 : position + 3'd1;
            // Generate output with single '1' at current position
            out <= 8'b0000_0001 << position;
        end
    end

endmodule