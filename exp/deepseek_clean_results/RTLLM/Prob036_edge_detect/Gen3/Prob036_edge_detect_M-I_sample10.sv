module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

    reg a_prev;  // Single register to store previous value
    wire clk_en; // Clock enable signal

    // Clock gating: only enable when input changes
    assign clk_en = (a != a_prev);

    // Sequential part with clock gating
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
        end
        else if (clk_en) begin
            a_prev <= a;
        end
    end

    // Shared inverter for both edge detection paths
    wire a_prev_n = ~a_prev;

    // Combinational part: optimized edge detection with shared logic
    assign rise = a_prev_n & a;  // Rising edge: 0->1 transition
    assign down = a_prev & ~a;   // Falling edge: 1->0 transition

endmodule