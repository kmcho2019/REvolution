module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

reg [3:0] next_q;
wire update_enable = load | ena;

always @(*) begin
    if (load)
        next_q = data;
    else if (ena)
        next_q = {1'b0, q[3:1]};
    else
        next_q = q;
end

always @(posedge clk or posedge areset) begin
    if (areset)
        q <= 4'b0;
    else if (update_enable)
        q <= next_q;
    // else hold q to reduce toggling (power optimization)
end

endmodule