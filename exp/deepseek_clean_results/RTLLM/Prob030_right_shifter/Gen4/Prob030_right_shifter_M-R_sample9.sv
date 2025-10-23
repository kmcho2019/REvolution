module right_shifter (
    input clk,
    input d,
    output reg [7:0] q = 0
);

wire [7:0] next_q;

// Combinational shift operation
assign next_q = {d, q[7:1]};

// Sequential update
always @(posedge clk) begin
    q <= next_q;
end

endmodule