module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

reg [3:0] next_out;

// Combinational logic to determine next count value
always @* begin
    if (!valid_count)
        next_out = out;                   // Hold current count if counting disabled
    else if (out == 4'd11)
        next_out = 4'b0000;              // Wrap around to zero on max count
    else
        next_out = out + 1'b1;           // Increment count
end

// Sequential logic with asynchronous active-low reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        out <= 4'b0000;                  // Reset count to zero
    else
        out <= next_out;                 // Update count on clock edge
end

endmodule