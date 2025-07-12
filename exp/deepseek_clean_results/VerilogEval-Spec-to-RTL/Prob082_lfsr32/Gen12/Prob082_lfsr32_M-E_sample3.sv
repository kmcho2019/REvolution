module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Define tap positions as a mask
localparam [31:0] TAP_MASK = 32'h800000C0;

always @(posedge clk) begin
    q <= reset ? 32'h1 : 
         {q[0], q[31:1]} ^ ({32{q[0]}} & TAP_MASK);
end

endmodule