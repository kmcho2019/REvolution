module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// One-hot register to hold the current count state
reg [9:0] one_hot;

integer i;

always @(posedge clk) begin
    if (reset) begin
        one_hot <= 10'b0000000001;  // Count = 0 position
    end else begin
        // Rotate left the one-hot bit
        if (one_hot[9])
            one_hot <= 10'b0000000001;
        else
            one_hot <= one_hot << 1;
    end
end

// Decode one-hot to binary count
always @(*) begin
    q = 4'd0;
    for (i = 0; i < 10; i = i + 1) begin
        if (one_hot[i])
            q = i[3:0];
    end
end

endmodule