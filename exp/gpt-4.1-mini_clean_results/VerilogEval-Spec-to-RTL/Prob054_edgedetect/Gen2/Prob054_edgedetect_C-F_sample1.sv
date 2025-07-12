module TopModule (
    input         clk,
    input  [7:0]  in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;

    // Initialize prev_in to zero at start to avoid unknown states (optional synthesis directive)
    initial prev_in = 8'b0;

    always @(posedge clk) begin
        // Detect 0->1 transitions: previous bit 0 and current bit 1
        pedge <= (~prev_in) & in;
        // Update previous input register for next cycle detection
        prev_in <= in;
    end

endmodule