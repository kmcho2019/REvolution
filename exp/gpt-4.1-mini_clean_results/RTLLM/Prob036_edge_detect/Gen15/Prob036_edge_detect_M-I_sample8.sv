module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    // Register to hold previous value of 'a'
    reg a_d;

    // Synchronous reset and edge detection
    always @(posedge clk) begin
        if (!rst_n) begin
            a_d <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            a_d <= a;
            // Generate one-clock-cycle pulse on rising edge of 'a'
            rise <= (~a_d) & a;
            // Generate one-clock-cycle pulse on falling edge of 'a'
            down <= a_d & (~a);
        end
    end

endmodule