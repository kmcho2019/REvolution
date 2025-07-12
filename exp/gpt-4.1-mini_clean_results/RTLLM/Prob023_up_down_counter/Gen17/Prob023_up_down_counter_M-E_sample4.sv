module up_down_counter (
    input  wire        clk,
    input  wire        reset,
    input  wire        up_down,
    output reg [15:0]  count
);

always @(posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else begin
        // Define increment as +1 if up_down=1, else -1
        // Use signed arithmetic to handle decrement naturally
        count <= count + (up_down ? 16'sd1 : -16'sd1);
    end
end

endmodule