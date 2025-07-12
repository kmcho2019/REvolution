module TopModule (
    input             clk,
    input      [7:0]  in,
    output     [7:0]  pedge
);

    reg [7:0] prev_in;

    // Capture previous input
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Positive edge detected one cycle after 0->1 transition
    assign pedge = (~prev_in) & in;

endmodule