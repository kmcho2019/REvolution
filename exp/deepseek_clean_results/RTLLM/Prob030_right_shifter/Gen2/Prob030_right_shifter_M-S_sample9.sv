module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

always @(posedge clk) begin
    q <= {d, q[7:1]};  // Right shift with new bit inserted at MSB
end

initial begin
    q = 8'b0;  // Initialization
end

endmodule