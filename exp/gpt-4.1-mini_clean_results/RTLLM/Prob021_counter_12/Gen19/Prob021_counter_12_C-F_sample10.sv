module counter_12 (
    input  wire       rst_n,        // Active low asynchronous reset
    input  wire       clk,          // Clock input
    input  wire       valid_count,  // Enable counting when high
    output reg [3:0]  out           // 4-bit count output
);

reg [3:0] next_count;

always @(*) begin
    if (valid_count) begin
        if (out == 4'd11)
            next_count = 4'd0;
        else
            next_count = out + 1'b1;
    end else begin
        next_count = out; // Hold current count if counting disabled
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        out <= 4'd0;
    else
        out <= next_count;
end

endmodule