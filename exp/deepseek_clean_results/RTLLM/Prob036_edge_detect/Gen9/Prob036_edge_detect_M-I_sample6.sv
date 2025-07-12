module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

    reg a_prev;
    wire clk_en;
    wire a_changed;

    // Clock gating when 'a' changes
    assign a_changed = (a != a_prev);
    assign clk_en = a_changed | (~rst_n);

    // Sequential logic with clock gating
    always @(posedge clk) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
        end else if (clk_en) begin
            a_prev <= a;
        end
    end

    // Shared inverter
    wire a_prev_n = ~a_prev;
    wire a_n = ~a;

    // Edge detection with registered outputs
    always @(posedge clk) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= a_prev_n & a;
            down <= a_prev & a_n;
        end
    end

endmodule