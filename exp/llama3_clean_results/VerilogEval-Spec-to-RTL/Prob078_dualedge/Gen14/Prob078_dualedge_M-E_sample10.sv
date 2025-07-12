module TopModule(
    input clk,
    input d,
    output reg q
);

// Clock signal conditioner
reg conditioned_clk;

// Conditioned clock signal generation
always @(posedge clk or negedge clk) begin
    conditioned_clk <= ~conditioned_clk;
end

// Single flip-flop implementation with conditioned clock signal
always @(posedge conditioned_clk) begin
    q <= d;
end

endmodule