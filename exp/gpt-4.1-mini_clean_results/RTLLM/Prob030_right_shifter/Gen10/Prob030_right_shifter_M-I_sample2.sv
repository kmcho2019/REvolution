module right_shifter (
    input wire clk,
    input wire rst_n,      // Active low synchronous reset
    input wire d,
    output reg [7:0] q
);

localparam WIDTH = 8;

initial q = {WIDTH{1'b0}};

always @(posedge clk) begin
    if (!rst_n)
        q <= {WIDTH{1'b0}};
    else
        q <= {d, q[WIDTH-1:1]};
end

endmodule