module JC_counter (
    input  wire        clk,
    input  wire        rst_n,
    output reg [63:0]  Q
);

wire feedback_bit = ~Q[0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        Q <= 64'd0;
    else
        Q <= {feedback_bit, Q[63:1]};
end

endmodule