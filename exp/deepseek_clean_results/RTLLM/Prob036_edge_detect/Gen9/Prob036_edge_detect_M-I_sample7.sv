module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

    reg a_prev;
    wire clk_enable;
    wire gated_clk;

    // Clock gating when input changes
    assign clk_enable = (a != a_prev) | (~rst_n);
    assign gated_clk = clk & clk_enable;

    // Sequential logic with gated clock
    always @(posedge gated_clk or negedge rst_n) begin
        if (!rst_n)
            a_prev <= 1'b0;
        else
            a_prev <= a;
    end

    // Optimized edge detection using XOR
    wire edge_detected;
    assign edge_detected = a ^ a_prev;
    assign rise = edge_detected & a;
    assign down = edge_detected & ~a;

endmodule