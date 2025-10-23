module JC_counter (
    input  wire        clk,
    input  wire        rst_n,
    output reg  [63:0] Q
);

genvar i;
wire [63:0] next_Q;

// Compute next state bits:
// MSB (bit 63) is inverse of current LSB (bit 0)
assign next_Q[63] = ~Q[0];

// For bits [62:0], next state is current Q shifted right by one bit
generate
    for (i = 0; i < 63; i = i + 1) begin : shift_bits
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