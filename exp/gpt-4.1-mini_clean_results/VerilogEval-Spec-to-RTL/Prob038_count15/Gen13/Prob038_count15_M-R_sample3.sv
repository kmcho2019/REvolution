module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Ripple carry increment logic using continuous assignments
wire n0, n1, n2, n3;

assign n0 = ~q[0];
assign n1 = q[1] ^ q[0];
assign n2 = q[2] ^ (q[1] & q[0]);
assign n3 = q[3] ^ (q[2] & q[1] & q[0]);

always @(posedge clk) begin
    if (reset)
        q <= 4'b0000;
    else
        q <= {n3, n2, n1, n0};
end

endmodule