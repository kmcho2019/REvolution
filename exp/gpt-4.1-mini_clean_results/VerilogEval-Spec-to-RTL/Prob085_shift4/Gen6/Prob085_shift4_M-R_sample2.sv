module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

reg [3:0] q_next;

// Combinational logic to determine next state of q
always @(*) begin
    if (load)
        q_next = data;                      // Load has highest priority
    else if (ena)
        q_next = {1'b0, q[3:1]};           // Shift right with zero in MSB
    else
        q_next = q;                        // Hold current state
end

// Asynchronous reset logic: clears q when areset rises
always @(posedge areset or posedge clk) begin
    if (areset)
        q <= 4'b0;
    else
        q <= q_next;
end

endmodule