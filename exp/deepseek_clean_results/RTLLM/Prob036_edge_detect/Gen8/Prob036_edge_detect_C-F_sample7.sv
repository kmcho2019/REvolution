module edge_detect (
    input wire clk,
    input wire rst_n,
    input wire a,
    output wire rise,
    output wire down
);

    reg a_prev;

    // Sequential block with synchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
        end else begin
            a_prev <= a;
        end
    end

    // Optimal combinational edge detection
    assign rise = a & ~a_prev;  // Rising edge: 0->1 transition
    assign down = ~a & a_prev;  // Falling edge: 1->0 transition

endmodule