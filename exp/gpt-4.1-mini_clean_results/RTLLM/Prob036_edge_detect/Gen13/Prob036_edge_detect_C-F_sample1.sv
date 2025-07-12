module edge_detect (
    input  wire clk,    // Clock input
    input  wire rst_n,  // Asynchronous active-low reset
    input  wire a,      // Input signal to detect edges on
    output reg  rise,   // Output high for one clock cycle on rising edge of 'a'
    output reg  down    // Output high for one clock cycle on falling edge of 'a'
);

    // Register to hold the previous value of 'a'
    reg a_d;

    // Sequential logic: update a_d with current 'a' or reset to 0 on rst_n
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_d <= 1'b0;
        else
            a_d <= a;
    end

    // Sequential logic to generate one-clock-cycle rise and down pulses,
    // registered to avoid glitches and ensure synchronous outputs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= (~a_d) & a;   // Assert rise on rising edge of 'a'
            down <= a_d & (~a);   // Assert down on falling edge of 'a'
        end
    end

endmodule