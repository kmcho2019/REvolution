module TopModule (
    input         clk,
    input  [7:0]  in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        // Detect rising edges: current bit is 1 and previous bit was 0
        pedge <= (~prev_in) & in;
        // Update previous input register
        prev_in <= in;
    end

endmodule