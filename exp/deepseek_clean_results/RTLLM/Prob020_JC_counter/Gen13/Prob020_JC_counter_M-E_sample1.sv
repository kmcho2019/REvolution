module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg next_bit;
reg [63:0] Q_pre;

// Precompute the next MSB value
always @(*) begin
    next_bit = ~Q[0];
end

// First phase (rising edge): Update precomputed value
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q_pre <= 64'b0;
    end else begin
        Q_pre <= {next_bit, Q[63:1]};
    end
end

// Second phase (falling edge): Update output register
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        Q <= Q_pre;
    end
end

endmodule