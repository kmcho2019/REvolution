module TopModule (
    input        clk,
    input  [7:0] in,
    output [7:0] pedge
);

    reg [7:0] prev_in;

    // Update previous input on rising edge of clock
    always @(posedge clk) begin
        prev_in <= in;
    end

    // pedge asserted when previous input was 0 and current input is 1 (rising edge)
    assign pedge = (~prev_in) & in;

endmodule