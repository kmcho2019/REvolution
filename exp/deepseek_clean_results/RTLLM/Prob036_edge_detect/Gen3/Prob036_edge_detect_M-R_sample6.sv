module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

    reg a_prev;  // Stores the previous value of 'a'

    // Sequential part: update previous value
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
        end
        else begin
            a_prev <= a;
        end
    end

    // Combinational part: edge detection
    assign rise = a & ~a_prev;  // 0->1 transition
    assign down = ~a & a_prev;  // 1->0 transition

endmodule