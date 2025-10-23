module edge_detect (
    input  wire clk,    // Clock input
    input  wire rst_n,  // Active-low synchronous reset
    input  wire a,      // Input signal to detect edges on
    output wire rise,   // High for one clock cycle on rising edge of 'a'
    output wire down    // High for one clock cycle on falling edge of 'a'
);

    // Register to hold previous value of 'a' for edge detection
    reg a_d;

    // Sequential logic block to update the delayed version of 'a'
    // or reset synchronously when rst_n is asserted low
    always @(posedge clk) begin
        if (!rst_n)
            a_d <= 1'b0;
        else
            a_d <= a;
    end

    // Combinational edge detection:
    // rise is asserted when 'a' changes from 0 to 1
    // down is asserted when 'a' changes from 1 to 0
    assign rise = ~a_d & a;
    assign down = a_d & ~a;

endmodule