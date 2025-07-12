module JC_counter #(parameter WIDTH = 64) (
    input clk,
    input rst_n,
    output reg [WIDTH-1:0] Q
);

// synthesis attribute async_reg of Q is "true";
// synthesis attribute shreg_extract of Q is "no";

// Johnson counter operation:
// - Right shift with inverted LSB as new MSB
// - Complete cycle: 2*WIDTH states
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) Q <= {WIDTH{1'b0}};
    else        Q <= {~Q[0], Q[WIDTH-1:1]};
end

endmodule