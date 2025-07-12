module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

    reg a_prev;
    wire a_prev_n = ~a_prev;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 0;
            rise <= 0;
            down <= 0;
        end
        else begin
            a_prev <= a;
            rise <= a_prev_n & a;
            down <= a_prev & ~a;
        end
    end

endmodule