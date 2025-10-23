module edge_detect (
    input           clk,
    input           rst_n,
    input           a,
    output reg      rise,
    output reg      down
);

reg prev_a;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        prev_a <= 0;
        rise <= 0;
        down <= 0;
    end else begin
        prev_a <= a;
        if (a == 1 && prev_a == 0) begin
            rise <= 1;
            down <= 0;
        end else if (a == 0 && prev_a == 1) begin
            down <= 1;
            rise <= 0;
        end else begin
            rise <= 0;
            down <= 0;
        end
    end
end

endmodule