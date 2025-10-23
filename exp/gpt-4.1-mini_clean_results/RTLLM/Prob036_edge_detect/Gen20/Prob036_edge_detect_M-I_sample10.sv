module edge_detect (
    input  wire clk,    // Clock input
    input  wire rst_n,  // Synchronous active-low reset
    input  wire a,      // Input signal to detect edges on
    output reg  rise,   // High for one clock cycle on rising edge of 'a'
    output reg  down    // High for one clock cycle on falling edge of 'a'
);

    // Register to hold previous value of 'a' for edge detection
    reg a_d;

    // Sequential logic block to update the delayed version of 'a'
    // and generate synchronous reset for all registers
    always @(posedge clk) begin
        if (!rst_n) begin
            a_d   <= 1'b0;
            rise  <= 1'b0;
            down  <= 1'b0;
        end else begin
            // Detect edges based on previous and current 'a'
            rise <= (~a_d) & a;  // 0 -> 1 transition
            down <= a_d & (~a);  // 1 -> 0 transition

            // Update delayed 'a'
            a_d <= a;
        end
    end

endmodule