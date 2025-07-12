module TopModule (
    input             clk,
    input      [7:0]  in,
    output reg [7:0]  pedge
);

    reg [7:0] prev_in;

    // Detect positive edge combinationally
    wire [7:0] posedge_detect = (~prev_in) & in;

    always @(posedge clk) begin
        prev_in <= in;        // store previous input
        pedge   <= posedge_detect; // output positive edge detection delayed by one cycle
    end

endmodule