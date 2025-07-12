module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output wire [7:0] out
);

    reg [2:0] index; // 3-bit index to represent positions 0 to 7

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            index <= 3'd0; // Initialize to position 0 (LSB)
        end else begin
            if (index == 3'd7)
                index <= 3'd0; // Wrap around to 0 after 7
            else
                index <= index + 3'd1;
        end
    end

    // Combinational output generation: only one bit high at the current index
    assign out = 8'b1 << index;

endmodule