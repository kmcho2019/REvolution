module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

wire [3:0] next_q;

assign next_q[3] = load ? data[3] : (ena ? 1'b0 : q[3]);
assign next_q[2] = load ? data[2] : (ena ? q[3] : q[2]);
assign next_q[1] = load ? data[1] : (ena ? q[2] : q[1]);
assign next_q[0] = load ? data[0] : (ena ? q[1] : q[0]);

always @(posedge clk or posedge areset) begin
    if (areset)
        q <= 4'b0000;
    else
        q <= next_q;
end

endmodule