module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

reg [3:0] next_out;

// Combinational logic to determine next count value
always @(*) begin
    if (!valid_count)
        next_out = out;              // Hold count if not valid to count
    else if (out == 4'd11)
        next_out = 4'd0;            // Wrap around when max reached
    else
        next_out = out + 1'b1;      // Increment count
end

// Sequential logic to update count or reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        out <= 4'd0;
    else
        out <= next_out;
end

endmodule