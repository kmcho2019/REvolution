module JC_counter (
    input  wire       clk,
    input  wire       rst_n,
    output reg [63:0] Q
);

wire next_lsb;
wire [63:0] next_Q;

// Next LSB is inverse of the MSB
assign next_lsb = ~Q[63];
// Shift left by one and insert next_lsb at LSB
assign next_Q = {Q[62:0], next_lsb};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        Q <= 64'b0;
    else
        Q <= next_Q;
end

endmodule