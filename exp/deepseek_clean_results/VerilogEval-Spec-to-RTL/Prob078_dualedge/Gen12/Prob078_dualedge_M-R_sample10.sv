module TopModule (
    input clk,
    input d,
    output q
);

reg last_clk;
reg q_pos, q_neg;

always @(posedge clk or negedge clk) begin
    if (clk ^ last_clk) begin  // Detect any edge
        if (clk) q_pos <= d;   // Positive edge
        else q_neg <= d;       // Negative edge
        last_clk <= clk;
    end
end

assign q = clk ? q_pos : q_neg;

endmodule