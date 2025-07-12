module JC_counter (
    input  wire       clk,
    input  wire       rst_n,
    output reg [63:0] Q
);

// Define reset value explicitly for clarity and possible synthesis benefits
localparam [63:0] RESET_VAL = 64'b0;

reg next_msb;
reg [63:0] next_Q;

always @(*) begin
    // Invert the LSB of Q to form next MSB
    next_msb = ~Q[0];
    // Shift right and insert next_msb at MSB
    next_Q = {next_msb, Q[63:1]};
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        Q <= RESET_VAL;
    else
        Q <= next_Q;
end

endmodule