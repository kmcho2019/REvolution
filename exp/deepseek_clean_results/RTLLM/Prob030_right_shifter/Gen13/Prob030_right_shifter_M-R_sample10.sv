module right_shifter (
    input clk,
    input d,
    output reg [7:0] q = 0
);

wire [7:0] next_q;

assign next_q = {d, q[7:1]};  // Combinational right shift with new MSB

always @(posedge clk) begin
    q <= next_q;  // Register the shifted value
end

endmodule