module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire D;

assign D = L ? R : (E ? w : Q);

always @(posedge clk) begin
    Q <= D;
end

endmodule