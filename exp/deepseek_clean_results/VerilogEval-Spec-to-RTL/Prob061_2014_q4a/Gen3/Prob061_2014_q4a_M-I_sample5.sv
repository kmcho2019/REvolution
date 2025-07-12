module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    Q <= L ? R : (E ? w : Q);  // More concise implementation with same functionality
end

endmodule