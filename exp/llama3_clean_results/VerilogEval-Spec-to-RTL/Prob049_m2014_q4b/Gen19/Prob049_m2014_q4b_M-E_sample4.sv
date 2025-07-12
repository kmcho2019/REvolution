module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

reg reset_latch_out;

always @(ar) begin
    if (ar) begin
        reset_latch_out <= 1'b0;
    end else begin
        reset_latch_out <= 1'b1;
    end
end

always @(posedge clk or negedge reset_latch_out) begin
    if (~reset_latch_out) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule