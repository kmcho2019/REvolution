module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    reg [2:0] position;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            position <= 3'd0;       // Initialize position to 0 (LSB)
        end else begin
            position <= position + 3'd1;  // Increment position modulo 8
        end
    end

    always @(*) begin
        // Generate one-hot output by shifting 1 to the left by position bits
        out = 8'b0000_0001 << position;
    end

endmodule