module TopModule (
    input          clk,
    input  [7:0]   in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    reg [7:0] transition_detected;

    always @(posedge clk) begin
        prev_in <= in;

        // Detect 0->1 transition: prev_in=0 and in=1
        transition_detected <= (~prev_in) & in;

        // Output the detection from previous cycle
        pedge <= transition_detected;
    end

endmodule