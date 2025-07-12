module TopModule (
    input        clk,
    input        reset,    // synchronous active-high reset
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 8'b0;
            pedge   <= 8'b0;
        end else begin
            pedge   <= (~prev_in) & in;  // detect 0-to-1 transitions
            prev_in <= in;               // update previous input
        end
    end

endmodule