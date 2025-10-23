module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0000;                 // asynchronous reset
    end else begin
        reg [3:0] next_q;
        if (load)
            next_q = data;            // load has highest priority
        else if (ena)
            next_q = {1'b0, q[3:1]}; // shift right with zero fill at MSB
        else
            next_q = q;               // hold current state

        if (q != next_q)               // update only if different to reduce toggling
            q <= next_q;
    end
end

endmodule