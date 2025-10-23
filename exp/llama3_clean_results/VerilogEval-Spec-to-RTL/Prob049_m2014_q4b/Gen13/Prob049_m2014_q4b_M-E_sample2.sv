module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

reg latch_out;

always @(posedge ar or negedge clk) begin
    if (ar) begin
        latch_out <= 1'b0;
    end else if (!clk) begin
        latch_out <= d;
    end
end

always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0;
    end else begin
        q <= latch_out;
    end
end

endmodule