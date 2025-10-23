module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_d1, a_d2;

    // Two-stage synchronizer for 'a' to track past states
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_d1 <= 1'b0;
            a_d2 <= 1'b0;
        end else begin
            a_d1 <= a;
            a_d2 <= a_d1;
        end
    end

    wire rising_edge  = (~a_d2) & a_d1;  // Rising edge detected at a_d1 from a_d2
    wire falling_edge = a_d2 & (~a_d1);  // Falling edge detected at a_d1 from a_d2

    // rise and down register logic:
    // rise sets to 1 on rising_edge, and resets to 0 on the next rising_edge after being set.
    // similarly for down.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            // Set rise to 1 on rising edge, or reset if already set and new rising edge appears
            if (rising_edge)
                rise <= ~rise;  // Toggle rise on each rising edge to keep it high until next rising edge
            // Set down to 1 on falling edge, or reset if already set and new falling edge appears
            if (falling_edge)
                down <= ~down;  // Toggle down on each falling edge to keep it high until next falling edge
        end
    end

endmodule