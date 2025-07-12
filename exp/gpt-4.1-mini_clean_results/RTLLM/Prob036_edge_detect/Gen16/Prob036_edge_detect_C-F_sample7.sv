module edge_detect (
    input  wire clk,    // Clock input
    input  wire rst_n,  // Asynchronous active-low reset
    input  wire a,      // Input signal to detect edges on
    output reg  rise,   // High for one clock cycle on rising edge of 'a'
    output reg  down    // High for one clock cycle on falling edge of 'a'
);

    // Register to hold previous value of 'a'
    reg a_prev;

    // Sequential logic: capture previous 'a' value
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_prev <= 1'b0;
        else
            a_prev <= a;
    end

    // Sequential logic: generate rise and down pulses
    // rise: asserted for one clk cycle after rising edge detected (a_prev=0, a=1)
    // down: asserted for one clk cycle after falling edge detected (a_prev=1, a=0)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= (~a_prev) & a;
            down <= a_prev & (~a);
        end
    end

endmodule