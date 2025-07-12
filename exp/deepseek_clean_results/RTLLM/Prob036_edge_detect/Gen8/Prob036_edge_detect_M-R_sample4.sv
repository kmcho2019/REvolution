module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

    wire a_delayed;
    reg a_prev = 1'b0;

    // Clock-gated delay element
    assign a_delayed = (clk & ~rst_n) ? 1'b0 : 
                      (clk) ? a : a_prev;

    // Update the previous value
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_prev <= 1'b0;
        else
            a_prev <= a_delayed;
    end

    // Edge detection logic
    assign rise = (a & ~a_prev) & ~rst_n;
    assign down = (~a & a_prev) & ~rst_n;

endmodule