module JC_counter #(
    parameter WIDTH = 64
)(
    input  wire               clk,
    input  wire               rst_n,
    input  wire               en,     // clock enable to reduce unnecessary toggling
    output reg [WIDTH-1:0]   Q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        Q <= {WIDTH{1'b0}};
    else if (en)
        Q <= {~Q[0], Q[WIDTH-1:1]};
    else
        Q <= Q; // hold current value when disabled
end

endmodule