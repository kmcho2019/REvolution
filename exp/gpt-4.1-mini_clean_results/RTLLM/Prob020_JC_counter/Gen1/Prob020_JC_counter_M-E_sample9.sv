module JC_counter (
    input  wire        clk,
    input  wire        rst_n,
    output reg [63:0]  Q
);

wire next_bit = ~Q[0];
wire [63:0] next_Q = {Q[62:0], next_bit};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        Q <= 64'b0;
    else
        Q <= next_Q;
end

endmodule