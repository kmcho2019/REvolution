module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

wire at_max = (out == 4'd11);
reg [3:0] next_count;

always @(*) begin
    if (!rst_n)
        next_count = 4'b0000;
    else if (valid_count) begin
        if (at_max)
            next_count = 4'b0000;
        else
            next_count = out + 1'b1;
    end else
        next_count = out;  // hold when counting disabled
end

always @(posedge clk) begin
    out <= next_count;
end

endmodule