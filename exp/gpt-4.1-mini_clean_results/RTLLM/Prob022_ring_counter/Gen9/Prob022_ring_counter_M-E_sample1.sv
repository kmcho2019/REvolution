module ring_counter (
    input  clk,
    input  reset,
    output reg [7:0] out
);

    reg [2:0] index;  // 3-bit index to track which bit is high

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            index <= 3'd0;  // Initialize index to 0, corresponding to LSB
        end else begin
            // Increment index modulo 8
            if (index == 3'd7)
                index <= 3'd0;
            else
                index <= index + 3'd1;
        end
    end

    always @(*) begin
        // Decode index to one-hot output
        out = 8'b00000000;
        out[index] = 1'b1;
    end

endmodule