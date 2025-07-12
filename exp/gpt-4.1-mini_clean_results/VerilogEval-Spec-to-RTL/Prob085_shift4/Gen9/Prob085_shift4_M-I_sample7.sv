module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

reg [3:0] next_q;

always @(*) begin
    if (load)
        next_q = data;          // load has highest priority
    else if (ena)
        next_q = q >> 1;        // shift right: q[3] becomes zero, q[0] shifts out
    else
        next_q = q;             // hold current state
end

always @(posedge clk or posedge areset) begin
    if (areset)
        q <= 4'b0;
    else
        q <= next_q;
end

endmodule