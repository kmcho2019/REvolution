module edge_detect (
    input  wire clk,    // Clock input
    input  wire rst_n,  // Asynchronous active-low reset
    input  wire a,      // Input signal to detect edges on
    output wire rise,   // High for one clock cycle on rising edge of 'a'
    output wire down    // High for one clock cycle on falling edge of 'a'
);

    // Register to hold previous value of 'a', synchronized to clk domain
    reg a_prev;

    // Sequential logic block: update a_prev at each rising clk edge,
    // or reset it asynchronously when rst_n is low.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_prev <= 1'b0;
        else
            a_prev <= a;
    end

    // Combinational detection of edges:
    // rise: previous 'a' was 0, current 'a' is 1 (rising edge)
    // down: previous 'a' was 1, current 'a' is 0 (falling edge)
    assign rise = (~a_prev) & a;
    assign down = a_prev & (~a);

endmodule