module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

reg [3:0] next_q;

// Combinational logic for next state
assign next_q = areset ? 4'b0 :         // Highest priority: reset
                load ? data :           // Medium priority: load
                ena ? {1'b0, q[3:1]} :  // Lowest priority: shift
                q;                      // Default: hold value

// Sequential logic (clocked update)
always @(posedge clk or posedge areset) begin
    q <= next_q;
end

endmodule