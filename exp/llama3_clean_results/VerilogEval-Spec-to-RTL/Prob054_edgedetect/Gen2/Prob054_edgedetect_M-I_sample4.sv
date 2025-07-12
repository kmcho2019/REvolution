module TopModule(
    input  clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_state;
reg [7:0] edge_detected;

always @(posedge clk) begin
    prev_state <= in;
    pedge <= edge_detected;
end

always @(*) begin
    edge_detected = (in & ~prev_state);
end

endmodule