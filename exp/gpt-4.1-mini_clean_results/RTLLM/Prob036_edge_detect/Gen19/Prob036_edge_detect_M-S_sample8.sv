module edge_detect (
    input  wire clk,    // Clock input
    input  wire rst_n,  // Active low synchronous reset
    input  wire a,      // Input signal to detect edges on
    output wire rise,   // High for one clock cycle on rising edge of 'a'
    output wire down    // High for one clock cycle on falling edge of 'a'
);

    reg a_d;

    // Synchronously reset and sample input 'a'
    always @(posedge clk) begin
        if (!rst_n)
            a_d <= 1'b0;
        else
            a_d <= a;
    end

    // Edge detection logic
    assign rise = ~a_d & a;
    assign down = a_d & ~a;

endmodule