module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;

    // Detect bits that have a rising edge (0->1) compared to prev_in
    wire [7:0] rising_edge = ~prev_in & in;

    // Enable signal to update registers only when at least one rising edge is detected
    wire update_enable = |rising_edge;

    always @(posedge clk) begin
        if (update_enable) begin
            pedge   <= rising_edge;  // latch only when rising edge occurs
            prev_in <= in;
        end else begin
            // Keep pedge and prev_in stable when no rising edge detected
            pedge   <= pedge;
            prev_in <= prev_in;
        end
    end

endmodule