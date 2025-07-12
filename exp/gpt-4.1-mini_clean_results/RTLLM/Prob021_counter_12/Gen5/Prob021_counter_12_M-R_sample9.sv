module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg  [3:0] out
);

reg [3:0] next_out;

always @(*) begin
    if (!valid_count) begin
        // Hold current value
        next_out = out;
    end else if (out == 4'd11) begin
        // Wrap around
        next_out = 4'b0000;
    end else begin
        // Increment
        next_out = out + 1;
    end
end

always @(posedge clk) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else begin
        out <= next_out;
    end
end

endmodule