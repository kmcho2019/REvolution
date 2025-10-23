module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] previous_state;
reg [7:0] pedge;

always @(posedge clk) begin
    pedge <= 8'b0;
    for (int i = 0; i < 8; i++) begin
        if (in[i] &&!previous_state[i]) begin
            pedge[i] <= 1'b1;
        end
    end
    previous_state <= in;
end

endmodule