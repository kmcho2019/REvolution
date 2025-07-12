module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

    reg a_prev;
    wire a_changed = (a != a_prev);  // Clock gating condition
    wire gated_clk = clk & a_changed;  // Gated clock
    
    // Sequential logic with clock gating
    always @(posedge gated_clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            a_prev <= a;
            // Registered outputs
            rise <= ~a_prev & a;  // Rising edge: 0->1
            down <= a_prev & ~a;  // Falling edge: 1->0
        end
    end

endmodule