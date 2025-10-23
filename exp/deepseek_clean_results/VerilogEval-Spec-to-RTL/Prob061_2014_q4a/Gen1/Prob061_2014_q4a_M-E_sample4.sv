module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire next_Q;

// Control logic: 00=hold, 01=shift, 1x=load (L has priority)
assign next_Q = L ? R : (E ? w : Q);

always @(posedge clk) begin
    Q <= next_Q;
end

endmodule