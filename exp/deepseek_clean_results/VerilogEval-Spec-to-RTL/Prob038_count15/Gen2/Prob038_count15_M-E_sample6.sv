module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire feedback;
wire [3:0] next_q;

// Feedback logic modified for binary counting sequence
assign feedback = ~(q[3] ^ q[2] ^ q[1] ^ q[0]);

// Next state calculation
assign next_q = reset ? 4'b0000 : 
               (q == 4'b1111) ? 4'b0000 : 
               {q[2:0], feedback} + (q[3] & ~q[2] & ~q[1] & ~q[0]);

always @(posedge clk) begin
    q <= next_q;
end

endmodule