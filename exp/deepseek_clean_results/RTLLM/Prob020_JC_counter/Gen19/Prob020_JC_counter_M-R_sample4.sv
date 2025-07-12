module JC_counter #(parameter WIDTH = 64) (
    input clk,
    input rst_n,
    output reg [WIDTH-1:0] Q
);

// synthesis attribute async_reg of Q is "true";
// synthesis attribute shreg_extract of Q is "no";

// Combinational next-state logic
wire [WIDTH-1:0] next_Q;
assign next_Q = {~Q[0], Q[WIDTH-1:1]};  // Explicit Johnson shift operation

// Sequential state update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) Q <= {WIDTH{1'b0}};  // Active-low reset
    else        Q <= next_Q;          // Normal operation
end

endmodule