module edge_detect(
    input  clk,
    input  rst_n,
    input  a,
    output rise,
    output down
);

reg prev_a;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        prev_a <= 0;
        rise  <= 0;
        down <= 0;
    end else begin
        prev_a <= a;
        if (a && !prev_a) begin
            rise  <= 1;
            down <= 0;
        end else if (!a && prev_a) begin
            rise  <= 0;
            down <= 1;
        end else begin
            rise  <= 0;
            down <= 0;
        end
    end
end

endmodule