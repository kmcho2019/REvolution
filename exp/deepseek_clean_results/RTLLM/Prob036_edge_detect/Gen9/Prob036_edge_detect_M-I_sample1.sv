module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

    reg a_prev;
    wire a_changed = (a != a_prev);  // Enable for clock gating

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end
        else begin
            // Clock-gated update of previous value
            if (a_changed) a_prev <= a;
            
            // Edge detection with shared inversion
            rise <= a & ~a_prev;
            down <= ~a & a_prev;
        end
    end

endmodule