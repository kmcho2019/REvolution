module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

reg [7:0] next_q;

initial begin
    q = 8'b0;
end

// Combinational logic for next state
always @(*) begin
    next_q = {d, q[7:1]};
end

// Sequential update of q
always @(posedge clk) begin
    q <= next_q;
end

endmodule