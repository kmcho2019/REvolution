module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

reg [3:0] next_q;

// Asynchronous reset handled separately
always @(posedge clk or posedge areset) begin
    if (areset)
        q <= 4'b0;
    else
        q <= next_q;
end

// Next state logic with priority: load > ena > hold
always @(*) begin
    if (load)
        next_q = data;
    else if (ena)
        next_q = {1'b0, q[3:1]};
    else
        next_q = q;
end

endmodule