module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

    reg a_prev;  // Single register to store previous value

    // Sequential part: update previous value on clock edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
        end
        else begin
            a_prev <= a;
        end
    end

    // Combinational part: optimized edge detection
    assign rise = ~a_prev & a;  // Rising edge: 0->1 transition
    assign down = a_prev & ~a;  // Falling edge: 1->0 transition

endmodule