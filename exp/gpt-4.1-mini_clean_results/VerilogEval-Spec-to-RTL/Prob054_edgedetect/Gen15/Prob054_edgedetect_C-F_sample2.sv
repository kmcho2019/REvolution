module TopModule (
    input             clk,
    input      [7:0]  in,
    output reg [7:0]  pedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        // Detect positive edge: previous bit = 0 and current bit = 1
        pedge   <= (~prev_in) & in;
        // Store current input for next cycle comparison
        prev_in <= in;
    end

endmodule