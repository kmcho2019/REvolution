module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] shift_reg;
reg clk_gated;

// Clock gating
always @(posedge clk) begin
    if (!resetn) begin
        clk_gated <= 1'b0;
    end else begin
        clk_gated <= 1'b1;
    end
end

// Shift register
always @(posedge clk) begin
    if (!resetn) begin
        shift_reg <= 4'b0000;
    end else if (clk_gated) begin
        shift_reg <= {shift_reg[2:0], in};
    end
end

assign out = shift_reg[3];

endmodule