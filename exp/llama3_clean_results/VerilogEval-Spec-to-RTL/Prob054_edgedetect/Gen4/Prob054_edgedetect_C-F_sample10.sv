module TopModule(
    input  clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_state;

always @(posedge clk) begin
    pedge <= in & ~prev_state;
    if (in != prev_state) begin
        prev_state <= in;
    end
end

endmodule