module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

wire Qnext;
wire update_enable;

assign Qnext = (j & ~Q) | (~k & Q);
assign update_enable = j | k;

always @(posedge clk) begin
    if (update_enable)
        Q <= Qnext;
end

endmodule