module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

always @(posedge clk) begin
    if (!rst_n)
        out <= 4'd0;
    else if (valid_count) begin
        if (out == 4'd11)
            out <= 4'd0;
        else
            out <= out + 1'b1;
    end
    else
        out <= out; // hold current value when valid_count == 0
end

endmodule