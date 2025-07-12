module TopModule(
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [3:0] count;

wire increment = slowena && (count != 4'd9);
wire [3:0] next_count = (reset) ? 4'b0000 : (increment) ? count + 1 : count;

always @(posedge clk) begin
    count <= next_count;
end

assign q = count;

endmodule