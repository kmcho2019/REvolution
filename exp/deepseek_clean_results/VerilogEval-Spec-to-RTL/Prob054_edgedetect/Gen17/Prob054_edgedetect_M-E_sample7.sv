module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    reg [7:0] prev_in;
    reg [7:0] xor_result;

    always @(posedge clk) begin
        // Calculate XOR between current and previous input
        xor_result <= in ^ prev_in;
        // Store current input for next cycle
        prev_in <= in;
    end

    // Detect positive edges: XOR=1 means change occurred,
    // AND with current input to ensure it was 0->1 transition
    assign pedge = xor_result & in;

endmodule