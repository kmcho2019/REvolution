module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire [2:0] next_q;

assign next_q = a ? q : 
               (q == 3'b110) ? 3'b000 : 
               q + 1;

initial begin
    q = 3'b100; // Initialize to 4
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule