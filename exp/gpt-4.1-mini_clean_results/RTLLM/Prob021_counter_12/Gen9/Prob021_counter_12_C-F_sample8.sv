module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

reg [3:0] next_out;
wire terminal_count = (out == 4'd11);

always @(*) begin
    if (valid_count) begin
        if (terminal_count)
            next_out = 4'd0;
        else
            next_out = out + 1'b1;
    end else begin
        next_out = out; // hold current value when not counting
    end
end

always @(posedge clk) begin
    if (!rst_n)
        out <= 4'd0;
    else
        out <= next_out;
end

endmodule