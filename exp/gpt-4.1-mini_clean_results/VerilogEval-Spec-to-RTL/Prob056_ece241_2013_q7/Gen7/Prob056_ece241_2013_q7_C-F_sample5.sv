module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

wire Qnext;
wire update;

assign Qnext = (j & ~Q) | (~k & Q);
assign update = j | k;

always @(posedge clk) begin
    if (update)
        Q <= Qnext;
    // else no assignment: hold state with no toggling
end

endmodule