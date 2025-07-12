module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_state;
reg [7:0] pedge;

always @(posedge clk) begin
    prev_state <= in;
    for (int i = 0; i < 8; i++) begin
        pedge[i] <= (prev_state[i] == 0) && (in[i] == 1);
    end
end

endmodule