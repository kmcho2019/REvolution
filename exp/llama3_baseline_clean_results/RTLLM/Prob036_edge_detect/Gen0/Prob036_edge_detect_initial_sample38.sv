module edge_detect(
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

reg prev_a;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        prev_a <= 0;
        rise <= 0;
        down <= 0;
    end else begin
        rise <= (a == 1 && prev_a == 0);
        down <= (a == 0 && prev_a == 1);
        prev_a <= a;
    end
end

endmodule