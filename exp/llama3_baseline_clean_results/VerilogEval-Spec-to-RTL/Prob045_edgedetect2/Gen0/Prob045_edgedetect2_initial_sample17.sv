module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_state;
reg [7:0] anyedge;

initial begin
    prev_state = 8'd0;
    anyedge = 8'd0;
end

always @(posedge clk) begin
    anyedge <= in ^ prev_state;
    prev_state <= in;
end

endmodule