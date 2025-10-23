module right_shifter(
    input clk,
    input d,
    output reg [7:0] q
);

initial q = 8'd0;

always @ (posedge clk) begin
    q[7] <= d;  // Insert the new input bit into the most significant position
    q[6:0] <= q[7:1];  // Right shift the contents of q by one bit
end

endmodule