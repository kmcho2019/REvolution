module TopModule(
    input  clk,
    input  [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_state;

always @(posedge clk) begin
    prev_state <= in;
end

always @(*) begin
    pedge = (in & ~prev_state);
end

endmodule