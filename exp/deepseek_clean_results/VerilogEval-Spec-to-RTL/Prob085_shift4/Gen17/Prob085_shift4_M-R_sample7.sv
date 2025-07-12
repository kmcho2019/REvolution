module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

wire [3:0] next_q;

// Priority encoded next state logic:
// 1. Reset has highest priority (handled in always block)
// 2. Load has priority over enable
// 3. Enable shifts if neither reset nor load is active
assign next_q = load ? data :
                ena  ? {1'b0, q[3:1]} :
                q;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;
    end else begin
        q <= next_q;
    end
end

endmodule