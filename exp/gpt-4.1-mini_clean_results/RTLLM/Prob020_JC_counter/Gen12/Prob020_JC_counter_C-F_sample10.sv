module JC_counter (
    input  wire       clk,
    input  wire       rst_n,
    output reg [63:0] Q
);

localparam [63:0] RESET_VAL = 64'b0;

reg        next_msb;
reg [63:0] next_Q;

always @(*) begin
    // Compute next MSB by inverting current LSB
    next_msb = ~Q[0];
    // Form next state by shifting right and inserting next_msb at MSB
    next_Q = {next_msb, Q[63:1]};
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        Q <= RESET_VAL;
    else
        Q <= next_Q;
end

endmodule