module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output wire rise,
    output wire down
);

    // Register to hold previous value of 'a'
    reg a_d;

    // Synchronous active-low reset
    always @(posedge clk) begin
        if (!rst_n)
            a_d <= 1'b0;
        else
            a_d <= a;
    end

    // Generate one-clock-cycle pulse on rising edge of 'a'
    assign rise = (~a_d) & a;

    // Generate one-clock-cycle pulse on falling edge of 'a'
    assign down = a_d & (~a);

endmodule