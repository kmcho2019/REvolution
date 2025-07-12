module edge_detect (
    input  wire clk,    // Clock input
    input  wire rst_n,  // Active low synchronous reset
    input  wire a,      // Input signal to detect edges on
    output reg  rise,   // Output high for one clock cycle on rising edge of 'a'
    output reg  down    // Output high for one clock cycle on falling edge of 'a'
);

    // Register to hold the previous value of 'a'
    reg a_d;

    // Sequential logic: synchronous reset, update previous 'a' and edge outputs
    always @(posedge clk) begin
        if (!rst_n) begin
            a_d  <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            // Detect rising edge: previous 'a' was 0, current 'a' is 1
            rise <= (~a_d & a);
            // Detect falling edge: previous 'a' was 1, current 'a' is 0
            down <= (a_d & ~a);
            // Update previous 'a'
            a_d <= a;
        end
    end

endmodule