module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

wire ce = valid_count;

reg [3:0] next_out;

always @(*) begin
    if (out == 4'd11 && ce)
        next_out = 4'b0000;
    else if (ce)
        next_out = out + 1'b1;
    else
        next_out = out; // hold current value when ce=0
end

always @(posedge clk) begin
    if (!rst_n)
        out <= 4'b0000;
    else
        out <= next_out;
end

endmodule