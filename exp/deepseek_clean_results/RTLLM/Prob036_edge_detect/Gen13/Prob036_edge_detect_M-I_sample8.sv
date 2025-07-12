module edge_detect (
    input clk,
    input rst_n,    // Synchronous reset
    input a,
    output reg rise,
    output reg down
);

    reg a_prev;
    wire clk_enable = (a != a_prev);  // Clock gating condition

    // Clock-gated sequential logic
    always @(posedge clk) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            if (clk_enable) begin
                a_prev <= a;
            end
            // Registered outputs
            rise <= ~a_prev & a;
            down <= a_prev & ~a;
        end
    end

endmodule