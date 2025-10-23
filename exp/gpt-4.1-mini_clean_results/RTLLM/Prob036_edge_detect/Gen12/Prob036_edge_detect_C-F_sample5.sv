module edge_detect (
    input  wire clk,    // Clock input
    input  wire rst_n,  // Asynchronous active-low reset
    input  wire a,      // Input signal to detect edges on
    output wire rise,   // Output high for one clock cycle on rising edge of 'a'
    output wire down    // Output high for one clock cycle on falling edge of 'a'
);

    // Register to hold the previous value of 'a'
    reg a_d;

    // Sequential logic: on rising edge of clk or falling edge of rst_n,
    // update a_d with current 'a' or reset to 0 when rst_n is low.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_d <= 1'b0;
        else
            a_d <= a;
    end

    // Combinational outputs: 
    // rise is high when previous 'a' was 0 and current 'a' is 1
    // down is high when previous 'a' was 1 and current 'a' is 0
    assign rise = ~a_d & a;
    assign down = a_d & ~a;

endmodule