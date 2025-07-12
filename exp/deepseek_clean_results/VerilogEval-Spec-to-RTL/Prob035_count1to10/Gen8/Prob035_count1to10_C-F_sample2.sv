module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;
wire [3:0] next_count;

// Optimized next state logic:
// 1. Reset has highest priority
// 2. Efficient terminal count check (10 = 1010 -> q[3]&q[1])
// 3. Normal increment otherwise
assign next_count = reset ? 4'b0001 :
                   (count[3] && count[1]) ? 4'b0001 :
                   count + 1;

// Sequential logic
always @(posedge clk) begin
    count <= next_count;
end

// Output assignment
assign q = count;

endmodule