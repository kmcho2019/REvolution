module TopModule(
    input clk,
    input d,
    output reg q
);

reg prev_d;

always @(posedge clk or negedge clk) begin
    prev_d <= d;
end

always @(posedge clk) begin
    if (d !== prev_d) begin
        q <= !q;
    end
end

endmodule