module right_shifter (
    input clk,
    input d,
    output reg [7:0] q = 0
);

wire [7:0] next_q = {d, q[7:1]};  // Combinational right shift with new MSB

always @(posedge clk) begin
    q <= next_q;  // Register update on clock edge
end

endmodule