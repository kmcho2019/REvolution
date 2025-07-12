module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

wire next_Q;

assign next_Q = (j & ~k)         // Set
              | ((~j) & (~k) & Q) // Hold
              | (j & k & ~Q);    // Toggle

always @(posedge clk) begin
    Q <= next_Q;
end

endmodule