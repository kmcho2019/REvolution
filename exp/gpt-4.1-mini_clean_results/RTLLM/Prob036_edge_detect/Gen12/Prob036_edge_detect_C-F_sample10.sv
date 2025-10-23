module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output wire rise,
    output wire down
);

    reg a_reg;

    // Register previous state of 'a' with asynchronous active-low reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_reg <= 1'b0;
        else
            a_reg <= a;
    end

    // Generate one-clock-cycle pulse on rising edge of 'a'
    assign rise = (~a_reg) & a;

    // Generate one-clock-cycle pulse on falling edge of 'a'
    assign down = a_reg & (~a);

endmodule