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
        next_q = data;               // load has highest priority
    else if (ena)
        next_q = {1'b0, q[3:1]};    // shift right with zero fill at MSB
    else
        next_q = q;                 // hold current state
end

always @(posedge clk or posedge areset) begin
    if (areset)
        q <= 4'b0000;               // asynchronous reset
    else
        q <= next_q;                // update register with next state
end

endmodule