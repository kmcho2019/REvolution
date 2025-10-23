module ring_counter (
    input  clk,
    input  reset,
    output [7:0] out
);

    reg [2:0] index;  // 3 bits to hold values 0 to 7

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            index <= 3'd0;  // Initialize to LSB
        end else begin
            index <= (index == 3'd7) ? 3'd0 : index + 3'd1;
        end
    end

    // One-hot output: only the bit at position 'index' is set
    assign out = 8'b1 << index;

endmodule