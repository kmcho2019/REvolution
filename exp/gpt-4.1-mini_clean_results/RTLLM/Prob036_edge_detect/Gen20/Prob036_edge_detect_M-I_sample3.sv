module edge_detect (
    input  wire clk,
    input  wire rst_n,  // Active low synchronous reset
    input  wire a,
    output wire rise,
    output wire down
);

    // Register to hold previous value of 'a'
    reg a_d;

    // Synchronous reset with non-blocking assignments
    always @(posedge clk) begin
        if (!rst_n)
            a_d <= 1'b0;
        else
            a_d <= a;
    end

    // One-cycle pulse on rising edge of 'a': when previous is 0 and current is 1
    assign rise = (~a_d) & a;

    // One-cycle pulse on falling edge of 'a': when previous is 1 and current is 0
    assign down = a_d & (~a);

endmodule