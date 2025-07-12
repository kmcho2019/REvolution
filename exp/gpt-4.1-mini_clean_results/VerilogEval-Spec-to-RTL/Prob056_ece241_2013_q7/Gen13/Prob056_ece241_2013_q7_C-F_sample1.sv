module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

// Initialize Q to 0 at simulation start for defined startup behavior
initial begin
    Q = 0;
end

always @(posedge clk) begin
    Q <= (j & ~Q) | (~k & Q);
end

endmodule