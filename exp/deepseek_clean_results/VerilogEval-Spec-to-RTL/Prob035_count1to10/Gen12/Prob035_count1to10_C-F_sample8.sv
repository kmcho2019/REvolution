module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Counter parameters
parameter START = 4'b0001;  // Starting value (1)
parameter END   = 4'b1010;  // Ending value (10)

// Combinational next state logic
wire [3:0] next_q = reset ? START : 
                   ((q == END) || (q[3] & q[1])) ? START : 
                   q + 1'b1;

// Sequential state update
always @(posedge clk) begin
    q <= next_q;
end

endmodule