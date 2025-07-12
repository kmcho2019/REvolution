module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_d;            // delayed version of 'a'
    reg rise_latch;     // latch to keep track if rise output should be held
    reg down_latch;     // latch to keep track if down output should be held

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_d       <= 1'b0;
            rise      <= 1'b0;
            down      <= 1'b0;
            rise_latch <= 1'b0;
            down_latch <= 1'b0;
        end else begin
            // detect edges by comparing current 'a' with delayed version 'a_d'
            wire rising_edge  = (a == 1'b1) && (a_d == 1'b0);
            wire falling_edge = (a == 1'b0) && (a_d == 1'b1);

            // update delayed 'a'
            a_d <= a;

            // Update rise_latch:
            // If a rising edge occurs, set rise_latch to 1, else keep previous
            // If a rising edge occurs again, latch remains at 1 until next rising edge clears it
            // But per spec, rise stays 1 from the clock after the edge is detected until the next rising edge appears again (so it toggles on each edge)
            // This is ambiguous in spec; interpreting "remain set to 1 until the corresponding edge appears again" means the rise output toggles on each rising edge.
            // So we can implement a toggle behavior: on each rising edge of 'a', rise toggles between 1 and 0.

            if (rising_edge) begin
                rise_latch <= ~rise_latch;
            end

            if (falling_edge) begin
                down_latch <= ~down_latch;
            end

            // Assign outputs as the current latch states
            rise <= rise_latch;
            down <= down_latch;
        end
    end

endmodule