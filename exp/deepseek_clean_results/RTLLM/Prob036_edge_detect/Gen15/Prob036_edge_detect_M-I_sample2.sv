module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

    reg a_prev;
    wire a_changed = (a != a_prev);
    reg gated_clk;

    // Clock gating logic
    always @(*) begin
        gated_clk = clk & a_changed;
    end

    // Main edge detection with synchronous reset
    always @(posedge gated_clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            a_prev <= a;
            rise <= a & ~a_prev;
            down <= ~a & a_prev;
        end
    end

endmodule