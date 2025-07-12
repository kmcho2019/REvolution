module JC_counter (
    input  wire        clk,
    input  wire        rst_n,
    output reg [63:0]  Q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        Q <= 64'd0;
    else if (Q[0] == 1'b0)
        Q <= {Q[62:0], 1'b1};  // shift left, insert 1 at LSB
    else
        Q <= {Q[62:0], 1'b0};  // shift left, insert 0 at LSB
end

endmodule