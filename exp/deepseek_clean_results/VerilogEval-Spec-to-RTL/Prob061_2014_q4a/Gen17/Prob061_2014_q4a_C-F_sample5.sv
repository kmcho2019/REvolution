module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    Q <= L ? R :           // Load has highest priority
         E ? w : Q;        // Then shift, else hold
end

endmodule