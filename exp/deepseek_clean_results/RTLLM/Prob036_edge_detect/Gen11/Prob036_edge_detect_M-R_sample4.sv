module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

    wire a_prev;
    reg a_prev_reg;

    // Synchronous storage of previous value using continuous assignment
    assign a_prev = a_prev_reg;

    // Update previous value on clock edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_prev_reg <= 1'b0;
        else
            a_prev_reg <= a;
    end

    // Edge detection logic
    assign rise = ~a_prev & a;  // Rising edge: 0->1
    assign down = a_prev & ~a;  // Falling edge: 1->0

endmodule