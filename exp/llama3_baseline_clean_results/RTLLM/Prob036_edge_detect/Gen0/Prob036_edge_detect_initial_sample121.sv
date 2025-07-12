module edge_detect(
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

reg prev_a;
reg rise_prev;
reg down_prev;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        prev_a <= 0;
        rise_prev <= 0;
        down_prev <= 0;
    end else begin
        prev_a <= a;
        rise_prev <= rise;
        down_prev <= down;
    end
end

always @(*) begin
    if (a == 1 && prev_a == 0) begin
        rise = 1;
        down = 0;
    end else if (a == 0 && prev_a == 1) begin
        rise = 0;
        down = 1;
    end else begin
        rise = 0;
        down = 0;
    end
end

endmodule