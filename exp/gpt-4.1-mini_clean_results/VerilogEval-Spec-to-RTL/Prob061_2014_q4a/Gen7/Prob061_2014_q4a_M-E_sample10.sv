module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire next_val;
assign next_val = L ? R : (E ? w : Q);

always @(posedge clk) begin
    Q <= next_val;
end

endmodule