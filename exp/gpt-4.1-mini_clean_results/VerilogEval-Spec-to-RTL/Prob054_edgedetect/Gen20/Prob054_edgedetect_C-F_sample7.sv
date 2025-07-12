module TopModule (
    input         clk,
    input  [7:0]  in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect = (~prev_in) & in;  // Detect 0->1 transition bits
    wire update_enable = |edge_detect;         // Enable update only if any bit has a 0->1 transition

    always @(posedge clk) begin
        if (update_enable) begin
            pedge   <= edge_detect;
            prev_in <= in;
        end else begin
            pedge   <= 8'b0;  // Clear pedge when no positive edge detected
            prev_in <= prev_in; // Hold previous input stable to avoid glitches
        end
    end

endmodule