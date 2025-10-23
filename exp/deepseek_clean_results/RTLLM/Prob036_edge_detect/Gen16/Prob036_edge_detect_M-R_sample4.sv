module edge_detect (
    input clk,
    input rst_n,  // Maintain interface compatibility
    input a,
    output rise,
    output down
);

    wire a_delayed;
    reg a_delayed_reg;

    // Create delayed version of 'a' using continuous assignment
    assign a_delayed = a_delayed_reg;

    // Clock-gated delay element
    always @(posedge clk) begin
        a_delayed_reg <= a;
    end

    // Edge detection logic
    assign rise = a & ~a_delayed;
    assign down = ~a & a_delayed;

endmodule