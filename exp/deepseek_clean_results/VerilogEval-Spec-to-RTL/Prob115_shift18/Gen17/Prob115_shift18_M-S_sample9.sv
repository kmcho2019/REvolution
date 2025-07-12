module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

always @(posedge clk) begin
    q <= load ? data : 
         ena ? (amount[1] ? 
               (amount[0] ? { {8{q[63]}}, q[63:8] } : { q[63], q[63:1] }) :  // Right shifts
               (amount[0] ? q << 8 : q << 1) :                               // Left shifts
         q;
end

endmodule