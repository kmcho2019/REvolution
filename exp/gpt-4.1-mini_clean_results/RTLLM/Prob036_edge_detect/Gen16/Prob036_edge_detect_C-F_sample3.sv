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
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_prev <= 1'b0;
        else
            a_prev <= a;
    end

    // Sequential logic block: generate rise and down signals as registered outputs
    // Outputs assert high for exactly one clock cycle immediately after edge detection,
    // then return to 0 until next edge is detected.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            // Rising edge detected: previous a=0, current a=1
            rise <= (~a_prev) & a;
            // Falling edge detected: previous a=1, current a=0
            down <= a_prev & (~a);
        end
    end

endmodule