module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [9:0] one_hot_count;

integer i;

// One-hot shift register state update
always @(posedge clk) begin
    if (reset) begin
        one_hot_count <= 10'b0000000001; // count = 0
    end else begin
        // Rotate the one-hot bit to the left
        if (one_hot_count == 10'b0100000000) // if '1' at position 9 (count=9)
            one_hot_count <= 10'b0000000001; // wrap around to count=0
        else
            one_hot_count <= one_hot_count << 1;
    end
end

// Decode one-hot to binary count q
always @(*) begin
    q = 4'd0;
    for (i = 0; i < 10; i = i + 1) begin
        if (one_hot_count[i])
            q = i[3:0];
    end
end

endmodule