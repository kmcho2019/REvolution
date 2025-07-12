module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

// Next count value calculation (combinational)
wire [3:0] next_count = (out == 4'd11) ? 4'd0 : (out + 1);

always @(posedge clk) begin
    if (!rst_n)
        out <= 4'd0;
    else if (valid_count)
        out <= next_count;
    else
        out <= out; // Hold current value when valid_count is 0
end

endmodule