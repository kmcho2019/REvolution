module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] prev_state;

always @(posedge clk) begin
    prev_state <= in;
end

assign anyedge = in ^ prev_state;

endmodule