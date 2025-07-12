module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

    wire a_prev;
    reg a_prev_reg;

    // Store previous value using continuous assignment
    assign a_prev = rst_n ? a_prev_reg : 1'b0;

    // Update previous value on clock edge
    always @(posedge clk) begin
        a_prev_reg <= a;
    end

    // Edge detection with reset handling
    assign rise = rst_n ? (~a_prev & a) : 1'b0;
    assign down = rst_n ? (a_prev & ~a) : 1'b0;

endmodule