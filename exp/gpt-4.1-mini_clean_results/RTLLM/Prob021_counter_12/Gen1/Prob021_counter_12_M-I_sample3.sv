module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

wire terminal_count;

// Terminal count is when count == 11 (4'b1011)
// We generate terminal_count combinationally: 
// out[3] & ~out[2] & out[1] & out[0]
assign terminal_count = (out == 4'd11);

always @(posedge clk) begin
    if (!rst_n)
        out <= 4'b0000;  // synchronous reset on active low rst_n handled in clock domain
    else if (valid_count) begin
        if (terminal_count)
            out <= 4'b0000;
        else
            out <= out + 1;
    end
end

endmodule