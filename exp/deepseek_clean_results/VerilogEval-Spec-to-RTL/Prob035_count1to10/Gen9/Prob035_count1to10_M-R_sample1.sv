module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

wire [3:0] next_count;
reg [3:0] count;

// Combinational next state logic
assign next_count = reset ? 4'b0001 :         // Synchronous reset to 1
                   (count == 4'b1010) ? 4'b0001 :  // Wrap around after 10
                   count + 1;                // Normal increment

// Sequential logic using clocked assignments
assign q = count;
always @(posedge clk) begin
    count <= next_count;
end

endmodule