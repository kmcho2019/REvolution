module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;
wire [3:0] next_count;

// Combinational next state logic
assign next_count = reset ? 4'b0 : (count + 1'b1);

// Sequential state update
always @(posedge clk) begin
    count <= next_count;
end

assign q = count;

endmodule