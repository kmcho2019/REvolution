module edge_detect (
    input  wire clk,    // Clock input
    input  wire rst_n,  // Asynchronous active-low reset
    input  wire a,      // Input signal to detect edges on
    output reg  rise,   // High for one clock cycle on rising edge of 'a'
    output reg  down    // High for one clock cycle on falling edge of 'a'
);

    // Register to hold previous value of 'a', synchronized to clk domain
    reg a_prev;

    // Sequential logic block: update a_prev at each rising clk edge,
    // or reset it asynchronously when rst_n is low.
    // Also generate rise and down pulses synchronized to clk.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
            rise   <= 1'b0;
            down   <= 1'b0;
        end else begin
            // Detect edges by comparing current 'a' and previous 'a'
            rise <= (~a_prev) & a;  // Rising edge detected on previous clock
            down <= a_prev & (~a);  // Falling edge detected on previous clock
            a_prev <= a;            // Update previous a for next cycle
        end
    end

endmodule