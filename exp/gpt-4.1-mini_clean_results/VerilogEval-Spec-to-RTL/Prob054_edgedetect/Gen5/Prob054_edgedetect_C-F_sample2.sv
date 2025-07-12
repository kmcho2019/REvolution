module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        pedge   <= (~prev_in) & in;  // detect rising edges relative to previous input
        prev_in <= in;               // update previous input for next cycle
    end

endmodule