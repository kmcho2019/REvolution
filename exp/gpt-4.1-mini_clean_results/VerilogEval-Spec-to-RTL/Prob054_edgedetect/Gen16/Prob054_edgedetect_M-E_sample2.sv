module TopModule (
    input          clk,
    input  [7:0]   in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        // Detect 0->1 transitions by comparing current input and previous input
        pedge <= (~prev_in) & in;
        // Update previous input register
        prev_in <= in;
    end

endmodule