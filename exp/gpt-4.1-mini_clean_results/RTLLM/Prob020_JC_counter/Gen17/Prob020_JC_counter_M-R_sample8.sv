module JC_counter (
    input  wire       clk,
    input  wire       rst_n,
    output reg [63:0] Q
);

reg [63:0] Q_next;

always @(*) begin
    // Next state: MSB is inverse of current LSB, rest shift right by one
    Q_next = {~Q[0], Q[63:1]};
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        Q <= Q_next;
    end
end

endmodule