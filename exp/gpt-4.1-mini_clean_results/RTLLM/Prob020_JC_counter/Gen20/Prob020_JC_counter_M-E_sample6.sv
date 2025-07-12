module JC_counter (
    input  wire       clk,
    input  wire       rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        Q <= 64'd0;
    else
        Q <= {Q[62:0], ~Q[0]};
end

endmodule