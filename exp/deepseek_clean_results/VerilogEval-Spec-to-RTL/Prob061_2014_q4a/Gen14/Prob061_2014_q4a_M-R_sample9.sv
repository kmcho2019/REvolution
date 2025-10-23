module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire load_selected;
wire shift_selected;
wire next_Q;

assign load_selected = L ? R : Q;
assign shift_selected = E ? w : Q;
assign next_Q = L ? load_selected : shift_selected;

always @(posedge clk) begin
    Q <= next_Q;
end

endmodule