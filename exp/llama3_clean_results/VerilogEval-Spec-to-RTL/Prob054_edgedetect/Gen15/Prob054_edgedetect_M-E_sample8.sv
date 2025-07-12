module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in;  // shift register to store previous input values

always @(posedge clk) begin
    prev_in <= in;  // update previous input values
    for (int i = 0; i < 8; i++) begin
        pedge[i] <= in[i] && !prev_in[i];  // detect 0 to 1 transition
    end
end

endmodule