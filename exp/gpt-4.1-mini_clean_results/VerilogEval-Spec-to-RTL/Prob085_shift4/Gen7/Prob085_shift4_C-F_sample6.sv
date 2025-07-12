module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

reg [3:0] next_q;

// Combinational next state logic with priority: load > ena > hold
always @(*) begin
    if (load)
        next_q = data;
    else if (ena)
        next_q = {1'b0, q[3:1]};
    else
        next_q = q;
end

// Asynchronous reset handled in a dedicated always block
always @(posedge areset) begin
    q <= 4'b0;
end

// Synchronous update on positive clock edge (no asynchronous reset here)
always @(posedge clk) begin
    if (!areset)      // Avoid overwriting asynchronous reset in reset cycle
        q <= next_q;
end

endmodule