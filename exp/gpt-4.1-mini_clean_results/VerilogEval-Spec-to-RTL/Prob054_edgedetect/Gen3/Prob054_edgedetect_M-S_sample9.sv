module TopModule (
    input        clk,
    input  [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;

always @(posedge clk) begin
    prev_in <= in;
end

assign pedge = (~prev_in) & in;

endmodule