module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

    wire a_delayed;
    reg a_delayed_reg;

    // Create delayed version of 'a' using continuous assignment
    assign a_delayed = a_delayed_reg;

    // Clock-gated delay element
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_delayed_reg <= 1'b0;
        end else begin
            a_delayed_reg <= a;
        end
    end

    // Edge detection logic
    assign rise = a & ~a_delayed;
    assign down = ~a & a_delayed;

endmodule