module JC_counter (
    input  wire       clk,
    input  wire       rst_n,
    output reg [63:0] Q
);

wire [63:0] next_Q;
genvar i;

// MSB is inverse of LSB
assign next_Q[63] = ~Q[0];

// Each other bit is the previous bit of Q
generate
    for (i = 0; i < 63; i = i + 1) begin : bit_shift_logic
        assign next_Q[i] = Q[i+1];
    end
endgenerate

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        Q <= 64'b0;
    else
        Q <= next_Q;
end

endmodule