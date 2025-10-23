module edge_detect (
    input  wire clk,    // Clock input
    input  wire rst_n,  // Asynchronous active-low reset
    input  wire a,      // Input signal to detect edges on
    output wire rise,   // High for one clock cycle on rising edge of 'a'
    output wire down    // High for one clock cycle on falling edge of 'a'
);

    // Register to hold previous value of 'a'
    reg a_prev;

    // Sequential logic: capture previous 'a' on clk rising edge;
    // asynchronously reset to 0 when rst_n is low
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_prev <= 1'b0;
        else
            a_prev <= a;
    end

    // Combinational logic: detect rising and falling edges
    assign rise = (~a_prev) & a;  // 0 -> 1 transition
    assign down = a_prev & (~a);  // 1 -> 0 transition

endmodule