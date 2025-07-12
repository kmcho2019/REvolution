module edge_detect(
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

reg prev_a;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        prev_a <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        rise <= (a && !prev_a);
        down <= (!a && prev_a);
        prev_a <= a;
    end
end

endmodule