module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

    reg [2:0] position; // 3 bits to index 0 to 7

    // Update position on clock or reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            position <= 3'd0;  // Start at LSB
        end else begin
            position <= (position == 3'd7) ? 3'd0 : position + 3'd1;
        end
    end

    // Generate output based on current position
    always @(*) begin
        out = 8'b0000_0001 << position;
    end

endmodule