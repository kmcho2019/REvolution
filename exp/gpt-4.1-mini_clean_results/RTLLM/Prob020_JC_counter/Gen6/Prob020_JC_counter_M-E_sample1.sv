module JC_counter (
    input  wire       clk,
    input  wire       rst_n,
    output reg [63:0] Q
);

wire next_msb;
wire [63:0] next_Q;

// Next MSB is Q[0] XOR 1, which is equivalent to ~Q[0]
assign next_msb = Q[0] ^ 1'b1;
// Shift right by one and insert next_msb at MSB
assign next_Q = {next_msb, Q[63:1]};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        Q <= 64'b0;
    else
        Q <= next_Q;
end

endmodule