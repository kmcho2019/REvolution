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
        rise <= 0;
        down <= 0;
        prev_a <= 0;
    end else begin
        rise <= 0;
        down <= 0;
        if (a &&!prev_a) begin
            rise <= 1;
        end else if (!a && prev_a) begin
            down <= 1;
        end
        prev_a <= a;
    end
end

endmodule