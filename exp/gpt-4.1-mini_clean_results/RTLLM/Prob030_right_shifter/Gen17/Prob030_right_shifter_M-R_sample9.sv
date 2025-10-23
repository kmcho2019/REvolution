module right_shifter (
    input  wire       clk,
    input  wire       d,
    output reg  [7:0] q
);

initial q = 8'b0;

wire [7:0] shifted_q;

assign shifted_q = {d, q[7:1]};

always @(posedge clk) begin
    q <= shifted_q;
end

endmodule