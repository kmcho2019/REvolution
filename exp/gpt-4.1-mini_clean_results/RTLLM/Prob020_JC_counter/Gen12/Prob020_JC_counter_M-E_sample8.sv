module JC_counter (
    input  wire       clk,
    input  wire       rst_n,
    output reg [63:0] Q
);

wire msb_in = Q[0] ^ 1'b1; // inverted LSB

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        Q <= 64'b0;
    else
        // rotate right by 1: Q[63:1] shifted right, Q[0] moves to Q[63], 
        // then override MSB with inverted LSB (msb_in)
        Q <= {msb_in, Q[63:1]};
end

endmodule