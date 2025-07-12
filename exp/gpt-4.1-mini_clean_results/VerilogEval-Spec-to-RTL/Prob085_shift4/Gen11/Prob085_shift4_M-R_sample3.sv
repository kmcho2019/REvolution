module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

// Compute next state directly as a wire using conditional operator
wire [3:0] next_q = load ? data : (ena ? {1'b0, q[3:1]} : q);

always @(posedge clk or posedge areset) begin
    if (areset)
        q <= 4'b0000;
    else
        q <= next_q;
end

endmodule