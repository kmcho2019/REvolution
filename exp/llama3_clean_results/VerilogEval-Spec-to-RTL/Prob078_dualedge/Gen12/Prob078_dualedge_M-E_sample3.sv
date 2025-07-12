module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_ff;  // Flip-flop output
reg clk_shifted;  // Phase-shifted clock signal

// Generate phase-shifted clock signal
always @(posedge clk or negedge clk) begin
    if (clk) begin
        clk_shifted <= 1'b0;
    end else begin
        clk_shifted <= 1'b1;
    end
end

// Multiplexer to select between data input and flip-flop output
always @(posedge clk or negedge clk) begin
    if (clk_shifted) begin
        q_ff <= d;
    end else begin
        q_ff <= q_ff;
    end
end

// Output assignment
assign q = q_ff;

endmodule