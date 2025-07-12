module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

wire [3:0] shifted_q = {1'b0, q[3:1]};
wire [3:0] next_q = load ? data : (ena ? shifted_q : q);
wire       ce = load | ena;

always @(posedge clk or posedge areset) begin
    if (areset)
        q <= 4'b0000;
    else if (ce)
        q <= next_q;
end

endmodule