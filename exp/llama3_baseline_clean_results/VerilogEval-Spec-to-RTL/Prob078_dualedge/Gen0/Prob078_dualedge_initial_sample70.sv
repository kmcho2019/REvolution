module TopModule (
    input clk,
    input d,
    output reg q
);

reg d_edge;
reg prev_clk;

always @(posedge clk) begin
    prev_clk <= 1'b1;
end

always @(negedge clk) begin
    prev_clk <= 1'b0;
end

always @(*) begin
    d_edge = d;
    if (~prev_clk) begin
        d_edge = d;
    end else begin
        d_edge = q;
    end
end

always @(posedge clk or negedge clk) begin
    q <= d_edge;
end

endmodule