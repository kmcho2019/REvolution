module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

parameter MAX_COUNT = 4'd9;  // Parameter for maintainability

// Combinational next state logic
wire [3:0] next_q = reset ? 4'b0000 : 
                   (q[3] & q[0]) ? 4'b0000 : 
                   q + 1'b1;

// Sequential register
always @(posedge clk) begin
    q <= next_q;
end

endmodule