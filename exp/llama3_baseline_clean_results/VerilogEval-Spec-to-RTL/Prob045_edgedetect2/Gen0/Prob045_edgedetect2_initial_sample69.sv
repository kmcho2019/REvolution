module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] prev_state;

always @(posedge clk) begin
    anyedge <= in ^ prev_state;
    prev_state <= in;
end

endmodule