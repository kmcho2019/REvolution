module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    reg [7:0] prev_in;

    // Register previous input
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Combinational output: pedge is high when prev_in was 0 and in is 1
    assign pedge = (~prev_in) & in;

endmodule