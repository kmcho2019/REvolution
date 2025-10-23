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
    next_q = load ? data : (ena ? (q >> 1) : q);
end

always @(posedge clk or posedge areset) begin
    if (areset)
        q <= 4'b0;
    else
        q <= next_q;
end

endmodule