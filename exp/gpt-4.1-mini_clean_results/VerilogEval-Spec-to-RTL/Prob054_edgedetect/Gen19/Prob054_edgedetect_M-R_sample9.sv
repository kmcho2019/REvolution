module TopModule (
    input         clk,
    input  [7:0]  in,
    output [7:0]  pedge
);

    reg [7:0] prev_in;

    // Update previous input at every clock edge
    always @(posedge clk) begin
        prev_in <= in;
    end

    // pedge is high when previous input was 0 and current input is 1
    assign pedge = (~prev_in) & in;

endmodule