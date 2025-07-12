module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

wire [7:0] shifted;

initial begin
    q = 8'b0;
end

assign shifted = {1'b0, q[7:1]}; // logical right shift by 1

always @(posedge clk) begin
    q <= {d, shifted[6:0]};
end

endmodule