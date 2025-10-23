module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

reg [3:0] next_out;

always @(*) begin
    if (out == 4'd11) begin
        next_out = 4'b0000;
    end else begin
        next_out = out + 1'b1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else if (valid_count) begin
        out <= next_out;
    end else begin
        out <= out;
    end
end

endmodule