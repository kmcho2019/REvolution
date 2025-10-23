module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

    reg a_prev;  // Stores the previous value of 'a'
    wire a_changed = (a != a_prev);  // Clock gating condition
    wire gated_clk = clk & a_changed;  // Gated clock

    // Sequential part: update previous value with clock gating
    always @(posedge gated_clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
        end
        else begin
            a_prev <= a;
        end
    end

    // Shared inverted version of a_prev
    wire a_prev_n = ~a_prev;

    // Combinational part: edge detection with shared inverter
    assign rise = a & a_prev_n;  // 0->1 transition
    assign down = ~a & a_prev;   // 1->0 transition

endmodule