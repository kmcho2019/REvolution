module JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

localparam WIDTH = 64;

always @(posedge clk) begin
    if (!rst_n) 
        Q <= {WIDTH{1'b0}};  // synchronous reset to 0
    else
        Q <= {~Q[0], Q[WIDTH-1:1]};
end

endmodule