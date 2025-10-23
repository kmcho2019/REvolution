module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    reg [7:0] transition_detected;

    always @(posedge clk) begin
        prev_in <= in;
        transition_detected <= (~prev_in) & in;  // Detect 0->1 transitions
        pedge <= transition_detected;            // Output one cycle after detection
    end

endmodule