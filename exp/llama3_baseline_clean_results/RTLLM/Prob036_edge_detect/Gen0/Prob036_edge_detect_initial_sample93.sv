module edge_detect(
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

reg prev_a;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        prev_a <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        if (a != prev_a) begin
            if (a == 1'b1) begin
                rise <= 1'b1;
                down <= 1'b0;
            end else begin
                rise <= 1'b0;
                down <= 1'b1;
            end
        end else begin
            rise <= 1'b0;
            down <= 1'b0;
        end
        prev_a <= a;
    end
end

endmodule