module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

wire is_ten;
wire [3:0] next_q;

// Detect if q == 10 (binary 1010) using minimal logic
assign is_ten = q[3] & ~q[2] & q[1] & ~q[0];

// Compute next count value: if q is 10, wrap to 1; else increment by 1
assign next_q = is_ten ? 4'd1 : (q + 4'd1);

always @(posedge clk) begin
    if (reset)
        q <= 4'd1;
    else
        q <= next_q;
end

endmodule