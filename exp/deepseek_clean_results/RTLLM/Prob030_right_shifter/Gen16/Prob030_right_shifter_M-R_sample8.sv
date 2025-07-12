module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

wire [7:0] next_state;

assign next_state = {d, q[7:1]};  // Combinational right shift logic

initial begin
    q = 8'b0;
end

always @(posedge clk) begin
    q <= next_state;  // Sequential register update
end

endmodule