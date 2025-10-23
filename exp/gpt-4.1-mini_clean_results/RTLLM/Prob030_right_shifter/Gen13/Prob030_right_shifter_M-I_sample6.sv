module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

initial q = 8'b0;

wire update_required;
assign update_required = (d != q[7]) || (q[6:0] != {7{q[7]}});

always @(posedge clk) begin
    if (update_required)
        q <= {d, q[7:1]};
end

endmodule