module edge_detect (
    input  wire clk,    // Clock input
    input  wire rst_n,  // Asynchronous active-low reset
    input  wire a,      // Input signal to detect edges on
    output reg  rise,   // High for one clock cycle on rising edge of 'a'
    output reg  down    // High for one clock cycle on falling edge of 'a'
);

    // Register to store previous state of 'a'
    reg a_prev;

    // Sequential block: register previous value of 'a' and generate rise/down pulses
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
            rise   <= 1'b0;
            down   <= 1'b0;
        end else begin
            // Detect edges by comparing current 'a' with 'a_prev'
            rise <= (~a_prev) & a;   // rise pulse: 0 -> 1 transition
            down <= a_prev & (~a);   // down pulse: 1 -> 0 transition
            a_prev <= a;             // update previous input
        end
    end

endmodule