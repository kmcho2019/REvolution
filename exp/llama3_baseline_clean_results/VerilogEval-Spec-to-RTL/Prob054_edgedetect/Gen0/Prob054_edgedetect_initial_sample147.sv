module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_state;

always @(posedge clk) begin
    prev_state <= in;
end

always @(posedge clk) begin
    for (int i = 0; i < 8; i++) begin
        pedge[i] <= (prev_state[i] == 1'b0) && (in[i] == 1'b1);
    end
end

endmodule