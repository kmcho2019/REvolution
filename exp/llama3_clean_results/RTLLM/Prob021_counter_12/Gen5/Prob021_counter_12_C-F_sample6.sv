module counter_12 (
    input   rst_n,
    input   clk,
    input   valid_count,
    output reg [3:0] out
);

reg [3:0] next_out;

always @(*) begin
    if (!rst_n) begin
        next_out = 4'b0000;
    end else if (valid_count) begin
        next_out = (out == 4'd11)? 4'b0000 : out + 1;
    end else begin
        next_out = out;
    end
end

always @(posedge clk) begin
    out <= next_out;
end

endmodule