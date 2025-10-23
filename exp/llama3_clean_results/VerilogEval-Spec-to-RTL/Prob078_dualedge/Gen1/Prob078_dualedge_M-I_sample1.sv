module TopModule(
    input  clk,
    input  d,
    output reg q
);

reg posedge_q;
reg negedge_q;
reg prev_clk;

always @(posedge clk) begin
    posedge_q <= d;
end

always @(negedge clk) begin
    negedge_q <= d;
end

always @(posedge clk or negedge clk) begin
    if (clk != prev_clk) begin
        if (clk) begin
            q <= posedge_q;
        end else begin
            q <= negedge_q;
        end
    end
    prev_clk <= clk;
end

endmodule