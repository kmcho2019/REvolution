module TopModule(
    input clk,
    input [7:0] d,
    output [7:0] q
);

// Declare 8 D flip-flops
reg [7:0] q;

// Initialize D flip-flops
always @ (posedge clk) begin
    q <= d;
end

endmodule