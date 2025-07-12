module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

reg [3:0] next_out;

// Combinational next state logic
always @(*) begin
    if (!valid_count)
        next_out = out;          // Hold current value if not counting
    else if (out == 4'd11)
        next_out = 4'b0000;     // Wrap around to 0 when max count reached
    else
        next_out = out + 1'b1;  // Increment count
end

// Sequential logic with synchronous active-low reset
always @(posedge clk) begin
    if (!rst_n)
        out <= 4'b0000;
    else
        out <= next_out;
end

endmodule