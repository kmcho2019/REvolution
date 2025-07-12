module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

wire Qnext;

// Combinational logic for next state based on JK inputs and current Q
assign Qnext = (j & ~Q) | (~k & Q);

always @(posedge clk) begin
    Q <= Qnext;
end

endmodule