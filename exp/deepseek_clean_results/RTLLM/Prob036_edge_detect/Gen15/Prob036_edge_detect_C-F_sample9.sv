module edge_detect (
    input clk,
    input rst_n,  // Interface compatibility only
    input a,
    output rise,
    output down
);

    reg a_prev = 1'b0;  // Initialized to 0 (simulation only)

    always @(posedge clk) begin
        a_prev <= a;
    end

    assign rise = ~a_prev & a;  // Explicit rising edge detection
    assign down = a_prev & ~a;  // Explicit falling edge detection

endmodule