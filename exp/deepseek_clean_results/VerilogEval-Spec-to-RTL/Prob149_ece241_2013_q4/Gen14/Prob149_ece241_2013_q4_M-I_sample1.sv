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
    reg rising_edge;

    // Track sensor state changes and detect rising water level
    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
            rising_edge <= 1'b1;  // Force dfr active during reset
        end else begin
            prev_s <= s;
            rising_edge <= (s > prev_s);
        end
    end

    // Nominal flow outputs
    assign fr0 = reset ? 1'b1 : (~s[2] | ~s[0]);  // Active when not above s[2] or below s[0]
    assign fr1 = reset ? 1'b1 : (~s[2] & ~s[1]);  // Active when below s[2] and s[1]
    assign fr2 = reset ? 1'b1 : (~s[2] & ~s[1] & ~s[0]); // Active only when all sensors off

    // Supplemental flow (active when rising or during reset)
    assign dfr = reset ? 1'b1 : (rising_edge & (|s));  // Only active for rising between sensors

endmodule