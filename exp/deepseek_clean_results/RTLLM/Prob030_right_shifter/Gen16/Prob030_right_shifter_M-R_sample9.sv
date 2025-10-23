module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

reg [7:0] q_next;

initial begin
    q = 8'b0;
end

// Combinational next-state logic
always @(*) begin
    q_next = {d, q[7:1]};  // Right shift and insert new bit at MSB
end

// Sequential element
always @(posedge clk) begin
    q <= q_next;
end

endmodule