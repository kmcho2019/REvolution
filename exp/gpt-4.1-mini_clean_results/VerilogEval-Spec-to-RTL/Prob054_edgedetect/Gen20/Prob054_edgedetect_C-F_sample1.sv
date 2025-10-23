module TopModule (
    input         clk,
    input  [7:0]  in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;

    // Detect 0->1 transitions per bit and register output synchronously
    always @(posedge clk) begin
        pedge   <= (~prev_in) & in;  // Positive edge detected bits
        prev_in <= in;               // Store current input for next comparison
    end

endmodule