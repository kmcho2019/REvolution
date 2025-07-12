module edge_detect (
    input  wire clk,    // Clock input
    input  wire rst_n,  // Asynchronous active-low reset
    input  wire a,      // Input signal to detect edges on
    output wire rise,   // High for one clock cycle on rising edge of 'a'
    output wire down    // High for one clock cycle on falling edge of 'a'
);

    // Register to store previous state of 'a', updated every clock cycle
    reg a_prev;

    // Sequential logic with asynchronous reset to capture previous 'a'
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_prev <= 1'b0;
        else
            a_prev <= a;
    end

    // Combinational logic: detect rising edge (0->1) and falling edge (1->0)
    assign rise = (~a_prev) & a;
    assign down = a_prev & (~a);

endmodule