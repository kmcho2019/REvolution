module edge_detect (
    input clk,
    input a,
    output rise,
    output down
);

    parameter INIT_VAL = 1'b0;  // Optional initialization value
    
    reg a_prev = INIT_VAL;  // Initialized value (simulation only)

    always @(posedge clk) begin
        a_prev <= a;
    end

    // Edge detection using continuous assignments
    assign rise = a & ~a_prev;
    assign down = ~a & a_prev;

endmodule