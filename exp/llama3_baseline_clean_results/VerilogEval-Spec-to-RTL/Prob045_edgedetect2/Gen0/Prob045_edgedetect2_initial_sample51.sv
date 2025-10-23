module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_state;

always @(posedge clk) begin
    prev_state <= in;
end

always @(*) begin
    for (int i = 0; i < 8; i++) begin
        anyedge[i] = (in[i] !== prev_state[i]);
    end
end

endmodule