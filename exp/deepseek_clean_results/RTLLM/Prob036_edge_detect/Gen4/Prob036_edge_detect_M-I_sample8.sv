module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

    reg a_prev;  // Stores the previous value of 'a'
    wire clk_en = (a != a_prev);  // Clock enable when 'a' changes

    // Sequential part: update previous value with clock gating
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
        end
        else if (clk_en) begin
            a_prev <= a;
        end
    end

    // Combinational part: optimized edge detection
    wire edge_detected = a ^ a_prev;
    assign rise = edge_detected & a;
    assign down = edge_detected & ~a;

endmodule