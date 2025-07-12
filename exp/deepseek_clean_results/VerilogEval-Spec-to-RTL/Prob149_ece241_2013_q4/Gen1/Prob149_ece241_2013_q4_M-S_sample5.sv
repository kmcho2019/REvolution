module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    reg [2:0] prev_s;

    // Track previous sensor readings for dfr calculation
    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
        end else begin
            prev_s <= s;
        end
    end

    // Nominal flow outputs directly from current sensors
    assign fr0 = ~(&s);                     // On unless all sensors are on
    assign fr1 = ~(s[1] | s[2]);             // On when below s[1]
    assign fr2 = ~|s;                        // On only when no sensors active

    // Supplemental flow when any sensor turns on (water rising)
    assign dfr = ((s[0] & ~prev_s[0]) ||     // s[0] newly on
                 (s[1] & ~prev_s[1]) ||     // s[1] newly on
                 (s[2] & ~prev_s[2])) &&     // s[2] newly on
                 ~(&s);                     // Not when all sensors on

endmodule