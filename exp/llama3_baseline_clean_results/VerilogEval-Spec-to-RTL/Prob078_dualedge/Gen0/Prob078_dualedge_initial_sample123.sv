module TopModule(
    input  clk,
    input  d,
    output q
);

reg q_reg;
wire rising_edge, falling_edge;

// Edge detection
always @(posedge clk or negedge clk) begin
    if (clk == 1'b1) rising_edge <= 1'b1;
    else rising_edge <= 1'b0;
end

assign falling_edge = ~rising_edge;

// First flip-flop for rising edge
reg rising_q;
always @(posedge clk) begin
    rising_q <= d;
end

// Second flip-flop for falling edge
reg falling_q;
always @(negedge clk) begin
    falling_q <= d;
end

// Final output selection based on current edge
always @(posedge rising_edge or negedge falling_edge) begin
    if (rising_edge) q_reg <= rising_q;
    else q_reg <= falling_q;
end

assign q = q_reg;

endmodule