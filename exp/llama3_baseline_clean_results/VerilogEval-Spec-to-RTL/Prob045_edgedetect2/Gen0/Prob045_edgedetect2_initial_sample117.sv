module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_state;
reg [7:0] anyedge;

always @(posedge clk) begin
    anyedge <= (in ^ prev_state);
    prev_state <= in;
end

endmodule