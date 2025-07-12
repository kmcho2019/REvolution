module JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

reg [63:0] next_Q;

always @(*) begin
    // Compute next state by shifting right and inserting complement of LSB at MSB
    next_Q = {~Q[0], Q[63:1]};
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        Q <= next_Q;
    end
end

endmodule