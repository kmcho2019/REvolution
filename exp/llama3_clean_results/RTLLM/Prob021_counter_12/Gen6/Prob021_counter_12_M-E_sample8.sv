module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

logic [3:0] counter_out;
logic counter_enable;
logic counter_reset;

// Control unit
always_comb begin
    if (!rst_n) begin
        counter_reset = 1'b1;
        counter_enable = 1'b0;
    end else if (valid_count) begin
        counter_reset = 1'b0;
        counter_enable = 1'b1;
    end else begin
        counter_reset = 1'b0;
        counter_enable = 1'b0;
    end
end

// Counter module with clock gating
logic gated_clk;
assign gated_clk = clk & counter_enable;

always_ff @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n || counter_reset) begin
        counter_out <= 4'b0000;
    end else if (counter_out == 4'd11) begin
        counter_out <= 4'b0000;
    end else begin
        counter_out <= counter_out + 1;
    end
end

assign out = counter_out;

endmodule