module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

// Combinational next state logic
wire [511:0] next_state;
assign next_state = {q[510:0], 1'b0} ^ {1'b0, q[511:1]};

// Sequential state update
always @(posedge clk) begin
    q <= load ? data : next_state;
end

endmodule