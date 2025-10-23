module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Efficient next-state calculation with pattern matching
wire [3:0] next_q = reset ? 4'b0 : 
                   (q[3] & q[0]) ? 4'b0 : 
                   q + 1'b1;

// Clean sequential block
always @(posedge clk) begin
    q <= next_q;
end

endmodule