module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

    reg a_prev;

    // Sequential logic: store previous value
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_prev <= 1'b0;
        else
            a_prev <= a;
    end

    // Combinational logic: edge detection
    assign rise = ~a_prev & a;  // Rising edge: 0->1
    assign down = a_prev & ~a;  // Falling edge: 1->0

endmodule