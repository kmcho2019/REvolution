module TopModule (
    input         clk,
    input  [7:0]  in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        pedge   <= (~prev_in) & in;  // Detect 0->1 edges based on previous input
        prev_in <= in;               // Update previous input
    end

endmodule